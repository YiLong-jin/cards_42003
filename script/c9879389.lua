--只属于你的偶像
function c9879389.initial_effect(c)
	c:EnableCounterPermit(0x7e2)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879389,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER) 
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9879389)
	e1:SetTarget(c9879389.sptg)
	e1:SetOperation(c9879389.spop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c9879389.drcon)
	e2:SetOperation(c9879389.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(c9879389.atkval)
	c:RegisterEffect(e3)
end
function c9879389.filter(c)
	return c:IsFaceup() and c:IsCanHaveCounter(0x7e2) 
end
function c9879389.filter1(c,e,tp)
	return c:IsCanHaveCounter(0x7e2)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9879389.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9879389.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9879389.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9879389.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x7e2)
	
end
function c9879389.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c9879389.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if tc:IsRelateToEffect(e) and tc:AddCounter(0x7e2,3) then
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9877281,0))  then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end 
	end  
end


function c9879389.cfilter1(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsCanHaveCounter(0x7e2)
end
function c9879389.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9879389.cfilter1,1,nil,tp)
end
function c9879389.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,100,REASON_EFFECT)~=0 then
		e:GetHandler():AddCounter(0x7e2,1)
	end
end

function c9879389.atkval(e,c)
	return e:GetHandler():GetCounter(0x7e2)*100
end