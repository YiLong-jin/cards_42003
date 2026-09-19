--来自“过去”的武者
function c9877691.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9877691,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9877691)
	e1:SetCost(c9877691.pcost)
	e1:SetTarget(c9877691.target)
	e1:SetOperation(c9877691.activate)
	c:RegisterEffect(e1)


	local e11=Effect.CreateEffect(c)  
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_HAND)
	e11:SetCountLimit(1,1877691)
	e11:SetCost(c9877691.negcost)
	e11:SetTarget(c9877691.sptg)
	e11:SetOperation(c9877691.spop)
	c:RegisterEffect(e11) 
end
function c9877691.ctilter(c)
	return  c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function c9877691.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877691.ctilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9877691.ctilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end

function c9877691.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end  
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end
function c9877691.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Destroy(tc,REASON_EFFECT)  
	end  
end




function c9877691.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c9877691.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877691.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	   if  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.CheckLPCost(tp,500)  and Duel.SelectYesNo(tp,aux.Stringid(9877691,0)) then
				Duel.PayLPCost(tp,500)
				local e11=Effect.CreateEffect(e:GetHandler())
				e11:SetDescription(aux.Stringid(9877691,2))
				e11:SetType(EFFECT_TYPE_SINGLE)
				e11:SetCode(EFFECT_ADD_CODE)
				e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e11:SetValue(9873029)
				e11:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e11)
				local e12=Effect.CreateEffect(c)
				e12:SetType(EFFECT_TYPE_FIELD)
				e12:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e12:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e12:SetRange(LOCATION_MZONE)
				e12:SetTargetRange(LOCATION_MZONE,0)
				e12:SetTarget(c9877691.indtg)
				e12:SetValue(aux.tgoval)
				e12:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e12)
	   end
end
function c9877691.indtg(e,c)
	return c:IsSetCard(0x17ec) and c:IsType(TYPE_XYZ)
end
