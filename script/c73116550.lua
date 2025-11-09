--”有兽如垩 腹若大釜“
local cm, m, o = GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c, cm.FusFilter3, 1, true)
	c:SetSPSummonOnce(73116550)

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.hspcon)
	e2:SetTarget(cm.hsptg)
	e2:SetOperation(cm.hspop)
	c:RegisterEffect(e2)

	
	
	
		--Activate
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetTarget(c73116550.target)
	e8:SetOperation(c73116550.activate)
	c:RegisterEffect(e8)
end	
	

function cm.FusFilter3(c)	
	return c:IsFusionSetCard(0x7ae) or c:IsFusionSetCard(0x8ae)
end

function cm.FusFilter2(c, tp, sc)
	return c:IsFusionSetCard(0x7ae) and Duel.GetLocationCountFromEx(tp, tp, c, sc) > 0
	 and c:IsAbleToRemoveAsCost()
end

function cm.hspcon(e, c)
	if c==nil then return true end
	local tp=c:GetControler()
	return  Duel.IsExistingMatchingCard(cm.FusFilter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)
end

function cm.hsptg(e, tp, eg, ep, ev, re, r, rp, chk, c)
	local g=Duel.GetMatchingGroup(cm.FusFilter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:CancelableSelect(tp,1,g:GetCount(),nil)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end

function cm.hspop(e, tp, eg, ep, ev, re, r, rp, c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
----------------------------------------------------------------------------------------------------------
function c73116550.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WYRM) and c:GetFlagEffect(73116550)==0
end
function c73116550.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_FIELD,e:GetHandler(),1,0,0)
end
function c73116550.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e10=Effect.CreateEffect(c)
	e10:SetCode(EFFECT_CHANGE_TYPE)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e10:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e10)

	if Duel.IsExistingMatchingCard(c73116550.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(73116550,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c73116550.filter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			----------------------------------------------
				--千年一叹
			local e8=Effect.CreateEffect(tc)
			e8:SetType(EFFECT_TYPE_FIELD)
				e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e8:SetCode(73116550)
			e8:SetRange(LOCATION_MZONE)
			e8:SetTargetRange(1,0)
			e8:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e8)
			---------------------------------------------
			local e4=Effect.CreateEffect(tc)
			e4:SetDescription(aux.Stringid(73116550,1))
			e4:SetCategory(CATEGORY_SEARCH)
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e4:SetRange(LOCATION_MZONE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			e4:SetCountLimit(1,m+100)
			e4:SetTarget(c73116550.thtg)
			e4:SetOperation(c73116550.thop)
			tc:RegisterEffect(e4)
			tc:RegisterFlagEffect(73116550,RESET_EVENT+RESETS_STANDARD+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(73116550,0))
		end
	end
end















---------------------------------------------------------————————————————————————————————————————————————————————————————————----------------------------------------------
function c73116550.thfilter(c,tp)
	return (c:IsSetCard(0x7ae) or c:IsSetCard(0x8ae)) and c:IsAbleToHand()
end
function c73116550.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73116550.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c73116550.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c73116550.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end







