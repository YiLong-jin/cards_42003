-- 战士典中典之死灵蓝蜡烛纯唐氏无限防哈攻哈两手抓打赢心脏只需消耗鼠标和关节耐久度最终fw心脏不敌战士给他唐完了


function c73122504.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)


	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c73122504.immval)
	c:RegisterEffect(e3)


	c:RegisterFlagEffect(73122504, 0, 0, 0, 0, 0)

	local e_atk=Effect.CreateEffect(c)
	e_atk:SetType(EFFECT_TYPE_SINGLE)
	e_atk:SetCode(EFFECT_UPDATE_ATTACK)
	e_atk:SetValue(c73122504.atkval)
	c:RegisterEffect(e_atk)


	local e_def=Effect.CreateEffect(c)
	e_def:SetType(EFFECT_TYPE_SINGLE)
	e_def:SetCode(EFFECT_UPDATE_DEFENSE)
	e_def:SetValue(c73122504.atkval)
	c:RegisterEffect(e_def)


	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73122504,4))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c73122504.op1)
	c:RegisterEffect(e1)


	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73122504,5))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c73122504.cond2)
	e2:SetOperation(c73122504.op2)
	c:RegisterEffect(e2)
end

function c73122504.immval(e, te)
	return te:GetOwner() ~= e:GetHandler()
end

function c73122504.atkval(e)
	return e:GetHandler():GetFlagEffectLabel(73122504) or 0
end

function c73122504.cond2(e)
	local c=e:GetHandler()
	return c:GetAttack()>=100 and c:GetDefense()>=100
end

function c73122504.op1(e,tp,eg,ep,ev,re,r,rp)
	-- 趣味播报：随机选取一段文字（字符串ID 6~15）
	-- 使用骰子和硬币生成1~10的随机数（保证同步）
	local function rand10()
		local r
		repeat
			local dice = Duel.TossDice(tp, 1)   -- 直接获得1-6
			local coin = Duel.TossCoin(tp, 1)   -- 直接获得0或1
			r = (coin * 6) + dice			   -- 得到1-12
		until r <= 10
		return r
	end
	local rnd = rand10()
	local str_id = 5 + rnd  -- 6~15
	Duel.Hint(HINT_OPSELECTED, 0, aux.Stringid(73122504, str_id))

	local c = e:GetHandler()
	if Duel.GetFieldGroupCount(tp, 0, LOCATION_DECK) == 0 then return end
	Duel.ConfirmDecktop(1 - tp, 1)
	local g = Duel.GetDecktopGroup(1 - tp, 1)
	local tc = g:GetFirst()
	local opt = Duel.SelectOption(tp, aux.Stringid(73122504, 1), aux.Stringid(73122504, 2), aux.Stringid(73122504, 3))

	local correct = false
	if opt == 0 then
		correct = bit.band(tc:GetType(), TYPE_MONSTER) ~= 0
	elseif opt == 1 then
		correct = bit.band(tc:GetType(), TYPE_SPELL) ~= 0
	else
		correct = bit.band(tc:GetType(), TYPE_TRAP) ~= 0
	end
	if correct then
		local ct = c:GetFlagEffectLabel(73122504) or 0
		c:SetFlagEffectLabel(73122504, ct + 1)
	end
	Duel.ShuffleDeck(1 - tp)
end

function c73122504.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Damage(1-tp,1,REASON_EFFECT)
	c:SetFlagEffectLabel(73122504, 0)
end