--月面的从者 十六夜咲夜
local s, id = GetID()
local m=99961030
local cm=_G["c"..m]
function c99961040.initial_effect(c)
--xyz summon
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
	
	
	
		-- 特殊召唤成功时检索
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,0))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetCountLimit(1,id)
	e11:SetCondition(s.thcon)
	e11:SetTarget(s.thtg)
	e11:SetOperation(s.thop)
	c:RegisterEffect(e11)
	
	 -- ②效果：去除素材特召+伤害
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+1)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
c99961040.Savior_Xiaoye=true
--Xyz Summon(normal)

-- 特殊召唤成功判定
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end

-- 检索条件
function s.thfilter(c)
	return c:IsCode(99961100) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end




-- 去除素材cost
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

-- 特召目标
function s.spfilter(c,e,tp)
	return c.Savior_Xiaoye and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.Damage(1-tp,100,REASON_EFFECT)
	end
	local e19=Effect.CreateEffect(e:GetHandler())
	e19:SetType(EFFECT_TYPE_FIELD)
	e19:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e19:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e19:SetTargetRange(1,0)
	e19:SetTarget(c99961040.splimit)
	e19:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e19,tp)
end
function c99961040.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c.Savior_Koumakan or c.Savior_Xiaoye)
end








function s.spfilter1(c,tp)-----素材检测
	return (c.Savior_Xiaoye and c:IsType(TYPE_QUICKPLAY)) or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c.Savior_Koumakan)
end

function s.spop2(e,tp,eg,ep,ev,re,r,rp,c)--------3素材xyz使用选择素材
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,nil,tp)
	local pg=e:GetLabelObject()
	pg:Merge(g)
	Duel.Overlay(c,pg)
	pg:Clear()
end

function s.spcon2(e,c,mc)------3素材xyz使用特召环境检测
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,2,nil,tp)
end


