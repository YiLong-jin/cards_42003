--？？？？？
local cm,m=GetID()
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

function cm.initial_effect(c)
	aux.AddCodeList(c,9877918)
	aux.AddFusionProcCodeFun(c,9877918,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),1,true,true)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCTCRPC(CATEGORY_POSITION,"etto+s",EVENT_SPSUMMON_SUCCESS,nil,0x10000,1,m)
	e1:SetCCTO(nil,nil,cm.sptg,cm.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCTCRPC(CATEGORY_TOHAND+CATEGORY_POSITION,EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP,nil,nil,0x10000,1,m*10)
	e2:SetCCTO(nil,nil,cm.thtg,cm.thop)
	c:RegisterEffect(e2)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanTurnSet() end
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,0x04)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsStatus),tp,0x04,0x04,aux.ExceptThisCard(e),STATUS_BATTLE_DESTROYED)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local c=e:GetHandler()
		if c:IsRelateToChain() and Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,0))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end