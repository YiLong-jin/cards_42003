--超可爱执行者飞马
function c65846913.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,65846671)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c65846913.settg)
	e1:SetOperation(c65846913.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65846671,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c65846913.filter)
	c:RegisterEffect(e3)
end
c65846913.SetCard_ZJ_CKAZXZ=true
function c65846913.setfilter(c)
	return c.SetCard_ZJ_CKAZXZ and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c65846913.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846913.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c65846913.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c65846913.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
function c65846913.filter(e,c)
	return c.SetCard_ZJ_CKAZXZ
end