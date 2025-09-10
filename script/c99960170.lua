--魔法之国的爱丽丝
local s,id,o=GetID()
Duel.LoadScript("c99960010.lua")
function s.initial_effect(c)
	c:EnableReviveLimit()

	--special summon condition
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e9)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetDescription(aux.Stringid(99960010,1))
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(shenqi_Savior.spcon1)
	e0:SetOperation(shenqi_Savior.spop1)
	c:RegisterEffect(e0)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e0:SetLabelObject(g)
	--special summon rule2
	local e0_1=Effect.CreateEffect(c)
	e0_1:SetType(EFFECT_TYPE_FIELD)
	e0_1:SetDescription(aux.Stringid(99960010,2))
	e0_1:SetCode(EFFECT_SPSUMMON_PROC)
	e0_1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0_1:SetRange(LOCATION_EXTRA)
	e0_1:SetCountLimit(1,100852)
	e0_1:SetCondition(shenqi_Savior.spcon11)
	e0_1:SetOperation(shenqi_Savior.spop11)
	c:RegisterEffect(e0_1)
	local g1=Group.CreateGroup()
	g1:KeepAlive()
	e0_1:SetLabelObject(g1)
	--xyzop
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(shenqi_Savior.xyzop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--xyzop2
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1_1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetCountLimit(1,100752)
			--e1_1:SetCondition(s.spcon111)
	e1_1:SetOperation(s.xyzop1)
	e1_1:SetLabelObject(e0_1)
	c:RegisterEffect(e1_1)
		
	
	
		--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99960170,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(shenqi_Savior.xyzcost)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
	
end
s.Savior_mojie=true
function s.xyzop1(e,tp,eg,ep,ev,re,r,rp)--------特殊召唤成功时叠放素材
	local c=e:GetHandler()
	local pg1=e:GetLabelObject():GetLabelObject()
	if c:GetSummonType()==SUMMON_TYPE_SPECIAL and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and #pg1>0 then
		for tc in aux.Next(pg1) do
			Duel.Overlay(c,tc)
		end
		pg1:Clear()
	end 
end

function s.spcon111(e,c,mc)-----2素材xyz使用特召环境检测
	local c=e:GetHandler()
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsPlayerAffectedByEffect(tp,99960010)
end















function s.thfilter(c,e,tp)
	return c.Savior_mojie and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false)) and c:IsFaceupEx()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if tc then
		if not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.SelectOption(tp,1190,1152)==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end







