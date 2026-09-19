--惊变态昆虫女王
function c10701896.initial_effect(c)
	aux.AddCodeList(c,10701896)
	-- ①：「惊变态昆虫女王」在自己场上只能有1只表侧表示存在。
	c:SetUniqueOnField(1,0,10701896)
	c:EnableReviveLimit()
	
	-- 不能通常召唤。把自己场上1只不能通常召唤的昆虫族怪兽解放的场合才能从手卡·墓地特殊召唤。
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCondition(c10701896.spcon)
	e0:SetTarget(c10701896.sptg)
	e0:SetOperation(c10701896.spop)
	c:RegisterEffect(e0)
	
	-- ②：昆虫族怪兽不会被效果破坏
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c10701896.indtg)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	
	-- ②：不能通常召唤的昆虫族怪兽的效果的发动以及那些发动的效果不会被无效化
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c10701896.effectfilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c10701896.effectfilter)
	c:RegisterEffect(e4)
	
	-- ③：1回合最多2次，让对方怪兽攻击力变0并特招衍生物
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10701896,0))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(2,10701896) -- 1回合最多2次
	e5:SetTarget(c10701896.atktg)
	e5:SetOperation(c10701896.atkop)
	c:RegisterEffect(e5)
end

-- --- 特殊召唤手续相关 ---
function c10701896.spfilter(c,tp,sc)
	-- sc 是特殊召唤的怪兽本身。这里使用 Duel.GetMZoneCount 判定解放该怪兽后是否有格子让 sc 登场
	return c:IsRace(RACE_INSECT) and not c:IsSummonableCard() and c:IsControler(tp)
		and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_TOFIELD)>0
end
function c10701896.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c10701896.spfilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c10701896.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c10701896.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function c10701896.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

-- --- ② 破坏抗性过滤 ---
function c10701896.indtg(e,c)
	return c:IsRace(RACE_INSECT)
end

-- --- ② 发动与效果不被无效化判定 ---
function c10701896.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsRace(RACE_INSECT) and not te:GetHandler():IsSummonableCard() 
end

-- --- ③ 攻击力变0与衍生物特招 ---
function c10701896.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c10701896.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c10701896.atkfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10701897,0,TYPES_TOKEN,100,100,1,RACE_INSECT,ATTRIBUTE_EARTH)
		and Duel.IsExistingTarget(c10701896.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10701896.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c10701896.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		-- 1. 攻击力变成 0
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		
		-- 2. 召唤「昆虫怪兽衍生物」
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,10701897,0,TYPES_TOKEN,100,100,1,RACE_INSECT,ATTRIBUTE_EARTH) then
			
			-- 【核心修正】：通过底层核心直接创造带有特定属性的 Token 实体，防止 cdb 未注册报错
			local token=Duel.CreateToken(tp,10701897)
			
			-- 使用 Step 分步特招法强行赋予属性，这是防爆红字最稳妥的官方组合拳
			if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
				-- 再次严谨确认 Token 属性
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_BASE_ATTACK)
				e2:SetValue(100)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e2)
				local e3=e2:Clone()
				e3:SetCode(EFFECT_SET_BASE_DEFENSE)
				e3:SetValue(100)
				token:RegisterEffect(e3)
			end
			Duel.SpecialSummonComplete()
		end
	end
end