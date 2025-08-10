--血剑吸血鬼之牙
local s, id = GetID()
function c99961110.initial_effect(c)
-- 效果①：特召+伤害回复
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- 计数器
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
s.Savior_Koumakan=true
s.Savior_Xiaoye=true
-- 特召filter



function s.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not ((rc:GetType(TYPE_QUICKPLAY) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and (rc.Savior_Xiaoye))
end
function s.spfilter(c,e,tp)
	return c.Savior_Xiaoye and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		
		-- 注册回合结束效果
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(s.damop)
		e1:SetReset(RESET_EVENT+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		
		local ge1=Effect.CreateEffect(e:GetHandler())
   		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c99961110.checkop)
		ge1:SetReset(RESET_EVENT+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(ge1,0)
	end
	local e19=Effect.CreateEffect(e:GetHandler())
	e19:SetType(EFFECT_TYPE_FIELD)
	e19:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e19:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e19:SetTargetRange(1,0)
	e19:SetTarget(c99961110.splimit)
	e19:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e19,tp)
end
function c99961110.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c.Savior_Koumakan or c.Savior_Xiaoye)
end

-- 速攻魔法发动计数

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc.Savior_Xiaoye and rc:IsType(TYPE_QUICKPLAY) then
	local maxct=Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)
	Debug.Message("血剑当前储存伤害次数："..maxct)
	end
end
-- 伤害回复处理
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)
	if ct>0 then
		local dam=ct*100
		Duel.Damage(1-tp,dam,REASON_EFFECT)
		Duel.Recover(tp,dam,REASON_EFFECT)
	end
end