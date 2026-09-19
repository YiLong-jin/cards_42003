--环指人体派大师 父辈 鸿潞
local s,id,o=GetID()
local SET_HZ=0x7fe0
local HZFLAG=id+300

function s.alterf(c)
	return c:IsSetCard(SET_HZ) and c:IsFaceup()
end

function s.xop(e, tp, chk)
	if chk == 0 then return (Duel.GetFlagEffect(tp,HZFLAG)>0 or Duel.GetFlagEffect(1 - tp,HZFLAG)>0) and Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

function s.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetValue(RACE_WARRIOR)
	c:RegisterEffect(e0)

	-- aux.AddXyzProcedure(c,s.mfilter,9,3,nil,nil,99)
	aux.AddXyzProcedureLevelFree(c, s.mfilter, aux.TRUE, 3, 3, s.alterf, aux.Stringid(id, 3), s.xop)
	
	c:EnableReviveLimit()

	-- local e1=Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_FIELD)
	-- e1:SetCode(EFFECT_SPSUMMON_PROC)
	-- e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	-- e1:SetRange(LOCATION_EXTRA)
	-- e1:SetCondition(s.xyzcon)
	-- e1:SetTarget(s.xyztg)
	-- e1:SetOperation(s.xyzop)
	-- e1:SetValue(SUMMON_TYPE_XYZ)
	-- c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_DESTROYED)
		ge:SetOperation(s.globalop)
		Duel.RegisterEffect(ge,0)
	end

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.copytg)
	e2:SetOperation(s.copyop)
	c:RegisterEffect(e2)

	local ge1=Effect.CreateEffect(c)
	ge1:SetDescription(aux.Stringid(id,1))
	ge1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	ge1:SetType(EFFECT_TYPE_IGNITION)
	ge1:SetRange(LOCATION_MZONE)
	ge1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ge1:SetCountLimit(1,id+100)
	ge1:SetTarget(s.getg)
	ge1:SetOperation(s.geop)
	local grant=Effect.CreateEffect(c)
	grant:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	grant:SetRange(LOCATION_MZONE)
	grant:SetTargetRange(LOCATION_MZONE,0)
	grant:SetTarget(s.grfilter)
	grant:SetLabelObject(ge1)
	c:RegisterEffect(grant)
end
function s.mfilter(c)
	return c:IsSetCard(SET_HZ)
end
function s.globalop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsPreviousLocation(LOCATION_MZONE) and tc:IsPreviousSetCard(SET_HZ)
			and tc:IsReason(REASON_EFFECT) then
			local p=tc:GetPreviousControler()
			Duel.RegisterFlagEffect(p,HZFLAG,RESET_PHASE+PHASE_END,0,1)
		end
	end
end

function s.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	if min and min>1 then return false end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,HZFLAG)>0
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function s.ovfilter(c,sc)
	return c:IsSetCard(SET_HZ) and c:IsFaceup() and c:IsCanBeXyzMaterial(sc)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc,c,og,min,max)
	if og and not min then return true end
	if chk==0 then return true end
	if min and min>1 then return false end
	local g=Duel.SelectMatchingCard(tp,s.ovfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
	g:KeepAlive()
	e:SetLabelObject(g)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		g=e:GetLabelObject()
	end
	if not g or g:GetCount()~=1 then return end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
	Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	c:CompleteProcedure()
	g:DeleteGroup()
end
-- ①
function s.cpfilter(c)
	return c:IsSetCard(SET_HZ) and (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP)
		and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(true,true,false)~=nil
end
function s.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		return c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
			and Duel.IsExistingMatchingCard(s.cpfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

function s.grfilter(e,c)
	return c:IsSetCard(SET_HZ) and c:IsFaceup()
end
function s.getg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.gspfilter(c,e,tp)
	return c:IsSetCard(SET_HZ) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local g=Group.FromCards(tc)
	local dg=Duel.Destroy(g,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.gspfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.gspfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
	end
	if dg==0 and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end