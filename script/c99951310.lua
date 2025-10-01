--伟大的寂静 艾可露西亚
local s, id = GetID()
function s.initial_effect(c)
	-- 灵摆设定
	c:EnableReviveLimit()
	
	aux.EnablePendulumAttribute(c,false)
	aux.AddFusionProcMix(c,false,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x673),c99951310.matfilter1,c99951310.matfilter2,nil)
	
	-- 灵摆效果①：连锁保护
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(s.pencon)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)
	 
	-- 怪兽效果①：连锁除外保护
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.moncon)
	e4:SetOperation(s.monop)
	c:RegisterEffect(e4)
	
	-- 怪兽效果②：破坏时放置灵摆
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99951310,3))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c99951310.pencon)
	e5:SetTarget(c99951310.pentg)
	e5:SetOperation(c99951310.penop)
	c:RegisterEffect(e5)
end
function c99951310.matfilter1(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT)
end
function c99951310.matfilter2(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK)
end
-- 灵摆效果①：连锁保护
function s.penfilter(c,tp)
	return c:IsSetCard(0x671) and c:IsControler(tp)
end

function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local chain=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
	return chain and chain:GetHandler():IsSetCard(0x671) 
		and re:GetHandlerPlayer()==1-tp
end

function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 发动不会被无效化
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetValue(s.efilter)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end

function s.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetHandler():IsSetCard(0x671)
end


-- 怪兽效果①：连锁除外保护

function s.monop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,3)) then
   	 local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 and  Duel.Remove(g,POS_FACEUP,REASON_EFFECT) then
			Duel.Hint(HINT_CARD,0,id)
   		 -- 未来战怪兽不受效果影响
		  	local e1=Effect.CreateEffect(c)
   		 e1:SetType(EFFECT_TYPE_FIELD)
   		 e1:SetCode(EFFECT_IMMUNE_EFFECT)
   		 e1:SetTargetRange(LOCATION_MZONE,0)
   		 e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x671))
   		 e1:SetValue(s.immval)
		 e1:SetReset(RESET_CHAIN)
   		 Duel.RegisterEffect(e1,tp)
	
   	 -- 攻击力上升
		local atk=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)*500
		if atk>0 and c:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
   			 end
		end
	end
end
function s.moncon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE,0,1,nil)
end

function s.costfilter(c)
	return c:IsSetCard(0x673) and c:IsAbleToRemove()
end

function s.immval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

-- 怪兽效果②：破坏时放置灵摆
function c99951310.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c99951310.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c99951310.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end