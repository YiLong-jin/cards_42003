--检票员的魔女化身
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

c9878634.Dopple=true
mR.DoppleChar[9878634]=9877883
function c9878634.initial_effect(c)
	aux.AddCodeList(c,9877883)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,9877883,c9878634.fusfilter2,2,true,true)

	aux.EnableChangeCode(c,9877883,LOCATION_MZONE+LOCATION_GRAVE)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit) 
	e0:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e0)



	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(9878634,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9878634)
	e1:SetTarget(c9878634.actg)
	e1:SetOperation(c9878634.acop)
	c:RegisterEffect(e1) 



	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(9878634,1))
	e13:SetCategory(CATEGORY_ATKCHANGE)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e13:SetCode(EVENT_CUSTOM+9878634)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1,1878634)
	e13:SetCondition(c9878634.atkcon)
	e13:SetTarget(c9878634.atktg)
	e13:SetOperation(c9878634.atkop)
	c:RegisterEffect(e13)
	aux.RegisterMergedDelayedEvent(c,9878634,EVENT_DESTROYED)
end
function c9878634.fusfilter2(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c9878634.desfil(c) 
	return c:IsFaceup()
end 
function c9878634.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9878634.desfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9878634.desfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9878634.desfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
end
function c9878634.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) then 
		Duel.BreakEffect()
		local dc=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		Duel.GetControl(dc,tp,PHASE_END,1) 
	end
end 




function c9878634.atkfilter1(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsType(TYPE_MONSTER) and c:GetBaseAttack()>0
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c9878634.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c9878634.atkfilter1,nil,tp)
	if #g==0 then return false end
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function c9878634.atkfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c9878634.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9878634.atkfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9878634.atkfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9878634.atkfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9878634.atkop(e,tp,eg,ep,ev,re,r,rp)
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