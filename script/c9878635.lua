--沉默的魔女化身
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

c9878635.Dopple=true
mR.DoppleChar[9878635]=9877873
function c9878635.initial_effect(c)
	aux.AddCodeList(c,9877873)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,9877873,c9878635.fusfilter2,2,true,true)

	aux.EnableChangeCode(c,9877873,LOCATION_MZONE)


	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit) 
	e0:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e0)


	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9878635,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,9878635)
	e1:SetTarget(c9878635.destg)
	e1:SetOperation(c9878635.desop)
	c:RegisterEffect(e1)   

	local e5=Effect.CreateEffect(c) 
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e5:SetCountLimit(1,9878635)
	e5:SetCondition(c9878635.spcon) 
	e5:SetTarget(c9878635.sptg)
	e5:SetOperation(c9878635.spop)
	c:RegisterEffect(e5)	
	
	
end
function c9878635.fusfilter2(c)
	return c:IsRace(RACE_SPELLCASTER)
end

function c9878635.ffilter(c,fc,sub,mg,sg)
	return c:IsRace(RACE_SPELLCASTER) or aux.IsCodeListed(c,9877141) 
end 
function c9878635.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9878635.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9878635,0)) then
		local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil) 
		Duel.Destroy(dg,REASON_EFFECT,LOCATION_REMOVED)
	end
end 



function c9878635.cfilter(c,tp,rp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsCode(9877873)
end
function c9878635.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9878635.cfilter,1,nil,tp,rp)
end
function c9878635.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9878635.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	   if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9878635,0)) then
		local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil) 
		Duel.Destroy(dg,REASON_EFFECT,LOCATION_REMOVED)
	   end
	end
end