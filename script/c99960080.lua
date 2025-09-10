--魔界的女仆 梦子
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
	e0:SetCondition(shenqi_Savior.spcon2)
	e0:SetOperation(shenqi_Savior.spop2)
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
		
	
	
	
	
			--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99960080,2))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCost(shenqi_Savior.cost)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)

	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99960080,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,99960080)
	e3:SetCost(shenqi_Savior.xyzcost)
	e3:SetOperation(s.immop)
	c:RegisterEffect(e3)
	
	
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





function s.immop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,6))
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,6))
end
function s.imfilter(c)
	return c.Savior_shenqi and c:IsType(TYPE_MONSTER)
end

function s.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and (re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_SPELL))
end

function s.thfilter(c)
	return c.Savior_shenqi and (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL)) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end



