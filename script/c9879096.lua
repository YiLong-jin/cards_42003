--纸机神-贵人
c9879096.zhiji=true
c9879096.zhijisheng=true
function c9879096.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	
	 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4) 
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(c9879096.fuslimit)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e7) 

	
	 local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(9879096,0))
	e22:SetCategory(CATEGORY_SUMMON)
	e22:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCode(EVENT_BATTLE_DAMAGE)
	e22:SetProperty(EFFECT_FLAG_DELAY)
	e22:SetCountLimit(1,9879096)
	e22:SetTarget(c9879096.target)
	e22:SetOperation(c9879096.operation)
	c:RegisterEffect(e22)
	
end
function c9879096.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end


function c9879096.filter(c)
	return c.zhijifu and c:IsType(TYPE_MONSTER) and c:IsSummonable(true,nil)
end
function c9879096.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879096.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9879096.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9879096.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end