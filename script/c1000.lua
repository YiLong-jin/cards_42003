--屁股 树人招来
function c1000.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1000.target)
	e1:SetOperation(c1000.activate)
	c:RegisterEffect(e1)
end
function c1000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1001,0x542b,0x4011,0,0,2,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
end
function c1000.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=5
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	ft=math.min(ft,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,1001,0x542b,0x4011,0,0,2,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	repeat
		local token=Duel.CreateToken(tp,1001)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		ft=ft-1
	until ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(1000,1))
	Duel.SpecialSummonComplete()
end