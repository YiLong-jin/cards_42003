--魔界的死亡天使 萨丽艾尔
local s,id,o=GetID()
dofile("expansions/script/c99960010.lua")
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
	e0:SetDescription(aux.Stringid(99960010,1))
	e0:SetType(EFFECT_TYPE_FIELD)
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
		
		
		
		
		
		
		
		
		
		--des
		
		
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(shenqi_Savior.cost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	
	
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99960070,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(shenqi_Savior.xyzcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.daop)
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


function s.thfilter(c)
	return c.Savior_shenqi and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.daop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end










function s.filter(c)
	return c:IsFaceup()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMinGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMinGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		else Duel.Destroy(tg,REASON_EFFECT) end
	end
end
