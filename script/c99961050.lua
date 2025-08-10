--月时计的馈赠•世界
local s, id = GetID()

function s.initial_effect(c)
	-- 魔法卡发动处理
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)




end
s.Savior_Xiaoye=true


function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,99961051,RESET_EVENT+RESET_CHAIN,0,1)
		local ge1=Effect.CreateEffect(e:GetHandler())
   		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.countop)
		ge1:SetCondition(s.countcon)
		ge1:SetReset(RESET_EVENT+RESET_CHAIN)
		Duel.RegisterEffect(ge1,tp)
			local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c99961050.aclimit1)
	e1:SetReset(RESET_EVENT+RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
		
end
function c99961050.aclimit1(e,re,tp)
	local rc=re:GetHandler()
	return (re:IsActiveType(TYPE_MONSTER) or (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)) or (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP))) and not rc.Savior_Xiaoye
end






function c99961050.condition(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetCurrentChain()<1
end
function s.countcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler().Savior_Xiaoye and re:IsActiveType(TYPE_QUICKPLAY)
end
-- 记录最大连锁数
function s.countop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local maxct=Duel.GetFlagEffect(tp,id)
	Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESET_CHAIN,0,1)
	local maxctex=maxct+1
	-- 调试用提示
	Debug.Message("这是第"..maxctex.."刀！")
end

-- 伤害计算
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Debug.Message("咲夜的世界·时停")
end


-- 伤害执行
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local ma=Duel.GetFlagEffect(tp,id)
	local fc=ma*100
	Duel.Damage(1-tp,fc,REASON_EFFECT)
	Debug.Message("咲夜的世界·时间开始流动")
end