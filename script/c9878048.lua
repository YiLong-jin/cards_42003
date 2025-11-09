--七海八千代 突破
function c9878048.initial_effect(c)
	aux.AddCodeList(c,9877883)
	 c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9878048.ffilter,2,true)

	aux.EnableChangeCode(c,9877883,LOCATION_MZONE+LOCATION_GRAVE)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e1)

	
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetCountLimit(1,9878048) 
	e3:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)  
	e3:SetTarget(c9878048.xsptg) 
	e3:SetOperation(c9878048.xspop) 
	c:RegisterEffect(e3)  

	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(9878048,1))
	e13:SetCategory(CATEGORY_ATKCHANGE)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e13:SetCode(EVENT_CUSTOM+9878048)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1,1878048)
	e13:SetCondition(c9878048.atkcon)
	e13:SetTarget(c9878048.atktg)
	e13:SetOperation(c9878048.atkop)
	c:RegisterEffect(e13)
	aux.RegisterMergedDelayedEvent(c,9878048,EVENT_DESTROYED)
	
end
function c9878048.ffilter(c,fc,sub,mg,sg)
	return aux.IsCodeListed(c,9877883) 
end 
function c9878048.xspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and aux.IsCodeListed(c,9877883)
end 
function c9878048.xsptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c9878048.xspfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end 
function c9878048.xspop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(c9878048.xspfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		local sg=g:Select(tp,1,1,nil):GetFirst() 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
	end 
end 


function c9878048.atkfilter1(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsType(TYPE_MONSTER) and c:GetBaseAttack()>0
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c9878048.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c9878048.atkfilter1,nil,tp)
	if #g==0 then return false end
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function c9878048.atkfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c9878048.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9878048.atkfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9878048.atkfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9878048.atkfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9878048.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if g:GetCount()>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			g=g:Select(tp,1,1,nil)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(g:GetFirst():GetBaseAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	e:GetLabelObject():DeleteGroup()
end