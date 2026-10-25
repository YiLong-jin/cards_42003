--彩羽·黑江 新鲜夏日
local cm,m=GetID()

--内置字段「魔法少女的夏日」
--get c.Magia_Summer_Vacation
cm.Magia_Summer_Vacation=true

function cm.initial_effect(c)
	aux.AddCodeList(c,9877873,9877918)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,9877873),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_LEAVE_GRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(0x04)
	e3:SetCountLimit(1,m*10)
	e3:SetCost(cm.atkcost)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
end

function cm.tgsfilter(c,tp)
	return aux.IsCodeListed(c,9877918) and c:IsType(TYPE_LINK) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(0x10) and cm.tgsfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgsfilter,tp,0x10,0,1,nil,tp) and Duel.GetLocationCount(tp,0x08)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.tgsfilter,tp,0x10,0,1,1,nil,tp)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if tc:IsRelateToChain() and c:IsRelateToChain() and Duel.GetLocationCount(tp,0x08)>0 and Duel.Equip(tp,tc,c,true,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetLabelObject(c)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e4=Effect.CreateEffect(c)
		e4:SetCategory(CATEGORY_ATKCHANGE)
		e4:SetType(EFFECT_TYPE_IGNITION)
		e4:SetRange(0x08)
		e4:SetCountLimit(1)
		e4:SetCost(cm.atkcost)
		e4:SetTarget(cm.atktg)
		e4:SetOperation(cm.atkop)
		tc:RegisterEffect(e4,true)
		Duel.EquipComplete()
	end
end


function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end

function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end

function cm.tgafilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end

function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgafilter,tp,0,0x04,1,nil) end
end

function cm.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,0x04,nil)
	if #g>0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end

function cm.tgdfilter(c,e,tp)
	return aux.IsCodeListed(c,9877918) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,0x0c,1,nil,0x6) and Duel.IsExistingMatchingCard(cm.tgdfilter,tp,0x10,0,1,nil,e,tp) and Duel.GetMZoneCount(tp,e:GetHandler())>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,0x0c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x10)
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,0x0c,1,1,nil,0x6)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT) then
			Duel.BreakEffect()
			if Duel.GetMZoneCount(tp)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=Duel.SelectMatchingCard(tp,cm.tgdfilter,tp,0x10,0,1,1,nil,e,tp)
				if #sg>0 then
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end