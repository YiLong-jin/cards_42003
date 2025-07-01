--机骸魔神 祸津暗鬼
function c10700920.initial_effect(c)
	aux.AddCodeList(c,10700925)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x27cd),c10700920.ffilter,true) 
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c10700920.spcon)
	e0:SetOperation(c10700920.spop)
	e0:SetValue(0x17cd)
	c:RegisterEffect(e0)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e0:SetLabelObject(g)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c10700920.eqop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1) 
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700920,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c10700920.rmcon)
	e2:SetTarget(c10700920.rmtg)
	e2:SetOperation(c10700920.rmop)
	c:RegisterEffect(e2)  
	--attack all
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_SINGLE)
	--e3:SetCode(EFFECT_ATTACK_ALL)
	--e3:SetValue(1)
	--e3:SetCondition(c10700920.aacon)
   --c:RegisterEffect(e3) 
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c10700920.efilter)
	c:RegisterEffect(e4)
end
function c10700920.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_MACHINE)
end
function c10700920.spcon(e,c,mc)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(c10700920.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c10700920.spfilter1(c,tp)
	return c:IsSetCard(0x27cd) and c:IsFaceup() and Duel.IsExistingMatchingCard(c10700920.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c10700920.spfilter2(c)
	return (c:IsRace(RACE_MACHINE) or c:IsAttribute(ATTRIBUTE_DARK)) and c:IsFaceup()
end
function c10700920.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g1=Duel.SelectMatchingCard(tp,c10700920.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c10700920.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	local pg=e:GetLabelObject()
	pg:Clear()
	pg:Merge(g1)
	pg:Merge(g2)
end
function c10700920.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pg=e:GetLabelObject():GetLabelObject()
	if c:GetSummonType()==SUMMON_TYPE_SPECIAL+0x17cd and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and #pg==2 then
		for tc in aux.Next(pg) do 
			if tc:IsLocation(LOCATION_MZONE) and Duel.Equip(tp,tc,c)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetLabelObject(c)
				e1:SetValue(c10700920.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
		pg:Clear()
	end
end
function c10700920.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10700920.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c10700920.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c10700920.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		if Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)>0 then
		  Duel.Damage(1-tp,bc:GetBaseAttack(),REASON_EFFECT)
		end
	end
end
function c10700920.aacon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,10700925)
end
function c10700920.efilter(e,te)
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end