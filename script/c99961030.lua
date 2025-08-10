--月与十六夜
local s, id = GetID()
local m=99961030
local cm=_G["c"..m]
function c99961030.initial_effect(c)
		--xyz summon
	c:EnableReviveLimit()
	
	-- 允许手卡速攻魔法作为素材
	--special summon condition
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e9)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_XYZ)
	e0:SetCondition(s.spcon2)
	e0:SetOperation(s.spop2)
	c:RegisterEffect(e0)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e0:SetLabelObject(g)
		--xyzop

	
	
	
	-- 特殊召唤成功时发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCountLimit(1,99961030)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	
	
	 -- ②效果：去除素材检索+伤害
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,1))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1,id+1)
	e11:SetCost(s.thcost1)
	e11:SetTarget(s.thtg1)
	e11:SetOperation(s.thop1)
	c:RegisterEffect(e11)
	
	
	
	
end
s.Savior_Xiaoye=true




-- 去除素材cost
function s.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

-- 检索目标
function s.thfilter11(c)
	return c.Savior_Xiaoye and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end

function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter11,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end

function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter11),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.Damage(1-tp,100,REASON_EFFECT)
	end
end







function s.spfilter1(c,tp)-----素材检测
	return (c.Savior_Xiaoye and c:IsType(TYPE_QUICKPLAY)) or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c.Savior_Koumakan)
end

function s.spop2(e,tp,eg,ep,ev,re,r,rp,c)--------3素材xyz使用选择素材
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,3,3,nil,tp)
	local pg=e:GetLabelObject()
	pg:Merge(g)
	Duel.Overlay(c,pg)
	pg:Clear()
end

function s.spcon2(e,c,mc)------3素材xyz使用特召环境检测
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,3,nil,tp)
end





-- 检查是否为"咲夜"速攻魔法
function s.mattg(e,c)
	return c.Savior_Xiaoye and c:IsType(TYPE_QUICKPLAY)
end


function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end

function s.thfilter(c)
	return c.Savior_Xiaoye and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Xyz Summon(normal)
