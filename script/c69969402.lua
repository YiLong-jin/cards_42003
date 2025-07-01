--狩魂使×幻变
function c69969402.initial_effect(c)
	c:SetSPSummonOnce(69969402)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,3,c69969402.ovfilter,aux.Stringid(69969402,0))
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(69969402,1))
	e0:SetCategory(CATEGORY_POSITION)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCost(c69969402.thcost)
	e0:SetTarget(c69969402.seqtg)
	e0:SetOperation(c69969402.seqop)
	c:RegisterEffect(e0)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetCondition(c69969402.poscon)
	e1:SetOperation(c69969402.adop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_SWAP_BASE_AD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c69969402.con)
	c:RegisterEffect(e2)
local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(69969402,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,69969402)
	e4:SetTarget(c69969402.sptg)
	e4:SetOperation(c69969402.spop)
	c:RegisterEffect(e4)
local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(69969402,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,69969402)
	e5:SetTarget(c69969402.sptg)
	e5:SetOperation(c69969402.spop)
	c:RegisterEffect(e5)	
	end
--0
function c69969402.ovfilter(c)
	return c:IsFaceup() and c:IsCode(69969400)
end
--1
function c69969402.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c69969402.gsfilter(c,e,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER) and c:IsCanTurnSet()
end
function c69969402.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function c69969402.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq)
	if c:GetSequence()==seq then
		local g=c:GetColumnGroup():Filter(c69969402.gsfilter,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(69969402,3)) then
			Duel.BreakEffect()
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
	end
end
--2
function c69969402.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return not c:IsStatus(STATUS_CONTINUOUS_POS) and ((np<3 and pp>3) or (pp<3 and np>3))
end
function c69969402.adop(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():GetFlagEffect(69969402)==0 then
			e:GetHandler():RegisterFlagEffect(69969402,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0)
		else
			e:GetHandler():ResetFlagEffect(69969402)
		end
	end
function c69969402.con(e)
	return e:GetHandler():GetFlagEffect(69969402)~=0
end
--3
function c69969402.filter(c,e,tp)
	return c:IsSetCard(0x69d) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c69969402.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969402.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and e:GetHandler():GetOverlayCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c69969402.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=c:GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c69969402.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
		 if tc then
		 tc:SetMaterial(nil)
		 if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		 tc:CompleteProcedure()
		 if c:IsRelateToEffect(e) and #g2>0 and tc:IsLocation(LOCATION_MZONE) then
		 Duel.Overlay(tc,g2) 
		 local c=e:GetHandler()
		 if c:IsExtraDeckMonster() then
		   Duel.BreakEffect()
		   Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end
end
end
end