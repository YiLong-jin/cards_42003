--纸机神-勾陈
c9879109.zhiji=true
c9879109.zhijisheng=true
function c9879109.initial_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4) 
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(c9879109.fuslimit)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e7)


	 local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e15:SetRange(LOCATION_MZONE)
	e15:SetTargetRange(LOCATION_MZONE,0)
	e15:SetTarget(c9879109.reftg)
	e15:SetValue(1)
	c:RegisterEffect(e15)

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9879109,0))
	e11:SetCategory(CATEGORY_RECOVER+CATEGORY_SUMMON)
	e11:SetType(EFFECT_TYPE_QUICK_O) 
	e11:SetCode(EVENT_FREE_CHAIN) 
	e11:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e11:SetRange(LOCATION_MZONE) 
	e11:SetCountLimit(1,9879109)
	e11:SetTarget(c9879109.thtg)
	e11:SetOperation(c9879109.thop)
	c:RegisterEffect(e11)
end
function c9879109.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c9879109.reftg(e,c)
	return c:IsFaceup() and c.zhijifu and c:IsLevel(4)
end


function c9879109.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,0,0,0)
end
function c9879109.sumfilter(c)
	return c:IsSummonable(true,nil) and c.zhiji
end
function c9879109.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	Duel.Recover(tp,1000,REASON_EFFECT)
	Duel.Recover(1-tp,1000,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c9879109.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9879109,2)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c9879109.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			if sg:GetCount()>0 then
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
	 end
end