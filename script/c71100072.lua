--银翼凶星☆天璇龙
local m = 71100072
local cm = _G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(cm.matcheck)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.spcon)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.condion)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.opeartion)
	c:RegisterEffect(e3)
end
function cm.matcheck(e,c)
	local cg=c:GetMaterial()
	local ct=cg:FilterCount(Card.IsSummonType,nil,SUMMON_TYPE_LINK)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ct*-1500)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0 end
	Duel.Release(c,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<1 then return end
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.condion(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local p=1-tp
	local f1=c:IsCanBeSpecialSummoned(e,0,p,false,false,POS_FACEUP,tp)
	local f2=c:IsAbleToExtra() and Duel.IsPlayerCanDraw(p,3) and (Duel.GetFieldGroupCount(p,LOCATION_ONFIELD,0)>2)
	if chk==0 then return f1 or f2 end
	local op=0
	if f1 and f2 then
		op=Duel.SelectOption(p,aux.Stringid(4918855,2),aux.Stringid(m,0))
	elseif f1 then
		op=Duel.SelectOption(p,aux.Stringid(4918855,2))
	else
		op=Duel.SelectOption(p,aux.Stringid(m,0))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
	elseif op==1 then
		local g=Duel.GetFieldGroup(p,LOCATION_ONFIELD,0)
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_TOEXTRA)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,3,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,p,3)
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
	end
end
function cm.opeartion(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local p=1-tp
	if not op then return end
	if op==0 and c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,p,tp,false,false,POS_FACEUP)
	elseif op==1 then
		local g=Duel.GetFieldGroup(p,LOCATION_ONFIELD,0)
		if #g<3 then return end 
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DESTROY)
		local sg=g:Select(p,3,3,nil)
		if Duel.Destroy(sg,REASON_EFFECT)==3 and Duel.Draw(p,3,REASON_EFFECT)==3 and c:IsRelateToEffect(e) and c:IsExtraDeckMonster() then
			Duel.BreakEffect()
			Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		end
	end
end