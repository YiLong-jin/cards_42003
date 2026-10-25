local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,8,8)
	--extra link material: opponent's 赛马娘 originally yours
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetTargetRange(0,LOCATION_MZONE)
	e0:SetTarget(s.exmatg)
	e0:SetValue(s.exmaval)
	c:RegisterEffect(e0)
	--atk gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--special summon trigger: choose 1 of 7 options
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(s.opttg)
	e2:SetOperation(s.optop)
	c:RegisterEffect(e2)
end
--link material filter: Level 7+ 赛马娘
function s.matfilter(c)
	return c:IsSetCard(0x417) and c:IsLevelAbove(7)
end
--extra link material target: 赛马娘 on opponent's field
function s.exmatg(e,c)
	return c:IsSetCard(0x417)
end
--extra link material value: only for this card, only if originally yours
function s.exmaval(e,lc,mg,c,tp)
	if lc~=e:GetHandler() then return false,nil end
	if c:GetOwner()~=tp then return false,nil end
	return true,true
end
--atk value: sum of base ATK of Level 7+ 赛马娘 on your field and GY
function s.atkfilter(c)
	return c:IsSetCard(0x417) and c:IsLevelAbove(7)
end
function s.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c)
	return g:GetSum(Card.GetBaseAttack)
end
--option target
function s.opttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
--option operation: choose 1 of 7
function s.optop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local opt=Duel.SelectOption(tp,
		aux.Stringid(id,1),
		aux.Stringid(id,2),
		aux.Stringid(id,3),
		aux.Stringid(id,4),
		aux.Stringid(id,5),
		aux.Stringid(id,6),
		aux.Stringid(id,7))
	s.register_option(c,opt+1)
end
--EMZ condition
function s.emzcon(e)
	local c=e:GetHandler()
	return c:GetSequence()>4
end
--other monster target (exclude self)
function s.othertg(e,c)
	return c~=e:GetHandler()
end
--spell/trap target
function s.sttg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
--register the chosen option's continuous effects
function s.register_option(c,opt)
	if opt==1 then
		--negate other monsters' effects
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetCondition(s.emzcon)
		e1:SetTarget(s.othertg)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		--prevent other monsters' effect activation
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(1,1)
		e2:SetCondition(s.emzcon)
		e2:SetValue(s.actlimit1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	elseif opt==2 then
		--negate spells/traps
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
		e1:SetCondition(s.emzcon)
		e1:SetTarget(s.sttg)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		--prevent spell/trap activation
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(1,1)
		e2:SetCondition(s.emzcon)
		e2:SetValue(s.actlimit2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	elseif opt==3 then
		--opponent cannot add from deck to hand
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_TO_HAND)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,1)
		e1:SetCondition(s.emzcon)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		--opponent cannot activate hand monster effects
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,1)
		e2:SetCondition(s.emzcon)
		e2:SetValue(s.actlimit3)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	elseif opt==4 then
		--opponent cannot activate deck/extra/GY/banished effects
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,1)
		e1:SetCondition(s.emzcon)
		e1:SetValue(s.actlimit4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	elseif opt==5 then
		--opponent cannot special summon unless return 1 hand to deck
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_COST)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,0x7f)
		e1:SetCondition(s.emzcon)
		e1:SetCost(s.hdcostchk)
		e1:SetOperation(s.hdcostop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	elseif opt==6 then
		--opponent cannot activate effects unless return 1 hand to deck
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ACTIVATE_COST)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetCondition(s.emzcon)
		e1:SetTarget(s.actcosttg)
		e1:SetCost(s.hdcostchk)
		e1:SetOperation(s.hdcostop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	elseif opt==7 then
		--unaffected by other card effects
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(s.emzcon)
		e1:SetValue(s.immuneval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		--cannot be destroyed by battle
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(s.emzcon)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
end
--activation limit functions
function s.actlimit1(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and rc~=e:GetHandler()
end
function s.actlimit2(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_SZONE) and rc:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.actlimit3(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_HAND) and rc:IsType(TYPE_MONSTER)
end
function s.actlimit4(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end
--activate cost target: all opponent's effect activations
function s.actcosttg(e,te,tp)
	return tp~=e:GetHandlerPlayer()
end
--hand-to-deck cost check and operation (options 5 and 6)
function s.hdcostchk(e,te_or_c,tp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil)
end
function s.hdcostop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
--immune value (option 7)
function s.immuneval(e,te)
	return te:GetOwner()~=e:GetHandler()
end
