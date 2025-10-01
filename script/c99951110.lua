--科斯特罗马·玛芙卡
function c99951110.initial_effect(c)
	aux.AddSynchroMixProcedure(c,c99951110.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)

	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(99951110,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,99951110)
	e0:SetCost(c99951110.excost)
	e0:SetTarget(c99951110.sptg)
	e0:SetOperation(c99951110.spop)
	c:RegisterEffect(e0)  

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99951110,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,99951111)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c99951110.drtg)
	e1:SetOperation(c99951110.drop)
	c:RegisterEffect(e1)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99951110,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,99951112)
	e5:SetTarget(c99951110.thtg)
	e5:SetOperation(c99951110.thop)
	c:RegisterEffect(e5)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetValue(c99951110.xyzlv)
	e2:SetLabel(4)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_LEVEL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetValue(c99951110.slevel)
	e3:SetLabel(4)
	c:RegisterEffect(e3)
end
function c99951110.matfilter1(c)
	return c:IsSetCard(0x671)
end
--e1
function c99951110.excostfilter(c)
	return c:IsSetCard(0x671) and c:IsAbleToHandAsCost() and bit.band(c:GetOriginalType(),TYPE_PENDULUM)==TYPE_PENDULUM
end
function c99951110.mfilter(c,tp)
	--local tp=c:GetControler()
	return c:GetSequence()<5 and c:IsLocation(LOCATION_MZONE) 
end
function c99951110.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c99951110.excostfilter,tp,LOCATION_ONFIELD,0,1,c) end
	local rg=Duel.GetMatchingGroup(c99951110.excostfilter,tp,LOCATION_ONFIELD,0,c,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		g=rg:Select(tp,1,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		g=rg:FilterSelect(tp,c99951110.mfilter,1,1,nil,tp)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	end
	Duel.SendtoHand(g,nil,REASON_COST)
	e:SetLabel(g:GetFirst():GetBaseAttack())
end
function c99951110.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99951110.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then   
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--e1
function c99951110.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,tp,1)
end
function c99951110.drop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
end
--e2--e3
function c99951110.xyzlv(e,c,rc)
	if rc:IsSetCard(0x671) then
		return c:GetLevel()+0x10000*e:GetLabel()
	else
		return c:GetLevel()
	end
end
function c99951110.slevel(e,c)
	if c:IsSetCard(0x671) then
		return e:GetHandler():GetLevel()+4*65536
	else
		return e:GetHandler():GetLevel()
	end
end

--e5
function c99951110.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x671) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c99951110.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99951110.thfilter,tp,LOCATION_EXTRA,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c99951110.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99951110.thfilter,tp,LOCATION_EXTRA,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end