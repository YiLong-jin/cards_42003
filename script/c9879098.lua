--纸机神-六合
c9879098.zhiji=true
c9879098.zhijisheng=true
function c9879098.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)


	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_UPDATE_ATTACK)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(LOCATION_MZONE,0)
	e12:SetValue(500)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e13)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4) 
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(c9879098.fuslimit)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e7)

	 local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(9879098,0))
	e22:SetCategory(CATEGORY_SUMMON)
	e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e22:SetCode(EVENT_SUMMON_SUCCESS) 
	e22:SetProperty(EFFECT_FLAG_DELAY) 
	e22:SetRange(LOCATION_MZONE)
	e22:SetCountLimit(1,9879098)
	e22:SetCondition(c9879098.thcon)
	e22:SetTarget(c9879098.target)
	e22:SetOperation(c9879098.operation)
	c:RegisterEffect(e22)
	local e33=e22:Clone() 
	e33:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e33) 
end
function c9879098.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end


function c9879098.thcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end  
function c9879098.filter(c)
	return c.zhijifu and c:IsType(TYPE_MONSTER) and c:IsSummonable(true,nil)
end
function c9879098.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879098.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9879098.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9879098.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end