--对精灵武装试作七型-天罚云
function c9879063.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)


	 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c9879063.atkval)
	c:RegisterEffect(e2)


	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9879063,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,9879063)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(c9879063.ctlcon)
	e4:SetTarget(c9879063.ctltg)
	e4:SetOperation(c9879063.ctlop)
	c:RegisterEffect(e4)

	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9879063,0))
	e12:SetCategory(CATEGORY_DESTROY)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1,9879063)
	e12:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e12:SetCondition(c9879063.descon)
	e12:SetTarget(c9879063.destg)
	e12:SetOperation(c9879063.desop)
	c:RegisterEffect(e12)
	
end
function c9879063.atkval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)*1000
end



function c9879063.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return tg:IsExists(Card.IsControler,1,nil,tp)
end

function c9879063.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c9879063.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
		   Duel.GetControl(c,1-tp)
		end
	end
end





function c9879063.tgdfilter(c)
	return c:IsType(TYPE_MONSTER) or c:IsLocation(0x04)
end
function c9879063.ctlcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return tg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c9879063.ctltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9879063.tgdfilter,tp,0x06,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0x06)
end
function c9879063.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,c9879063.tgdfilter,tp,0x06,0,1,1,c):GetFirst()
	if tc then
		if tc:IsLocation(0x04) then Duel.HintSelection(Group.FromCards(tc)) end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local c=e:GetHandler()
			if c:IsRelateToChain() and not c:IsImmuneToEffect(e) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(2000)
				c:RegisterEffect(e1)
				local e11=Effect.CreateEffect(c)
				e11:SetType(EFFECT_TYPE_SINGLE)
				e11:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
				e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e11:SetValue(1)
				e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e11)
			end
		end
	end
end
