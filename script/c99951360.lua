--舞台背后的世界
local s,id=GetID()
function s.initial_effect(c)	
	-- 效果①：把额外1只6星·7星·9星的「六翼」怪兽给对方观看才能发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 筛选六翼怪兽（只包括6、7、9星）
function s.filter(c)
	return c:IsSetCard(0x675) and c:IsType(TYPE_MONSTER) and (c:GetLevel()==6 or c:GetLevel()==7 or c:GetLevel()==9)
end

-- 检查9星效果是否可以处理
function s.lv9check(tp)
	local g1=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x675) -- 六翼怪兽
	local g2=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x671) -- 未来战怪兽
	return #g1>0 or #g2>0
end

-- 检查7星效果是否可以处理
function s.lv7check(tp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x671) -- 墓地的未来战怪兽
	return #g>0
end

-- 检查6星效果是否可以处理
function s.lv6check(tp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil) -- 对方场上的卡
	return #g>0
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 检查额外卡组是否有符合条件的怪兽
		local exg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_EXTRA,0,nil)
		if #exg==0 then return false end
		
		-- 检查至少有一个等级的效果在当前情况下可以处理
		return s.lv9check(tp) or s.lv7check(tp) or s.lv6check(tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,1-tp,LOCATION_ONFIELD)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 创建一个只包含可处理等级的筛选器
	local function available_filter(c)
		if not s.filter(c) then return false end
		local lv=c:GetLevel()
		if lv==9 then return s.lv9check(e:GetHandlerPlayer()) end
		if lv==7 then return s.lv7check(e:GetHandlerPlayer()) end
		if lv==6 then return s.lv6check(e:GetHandlerPlayer()) end
		return false
	end
	
	-- 把额外1只6星·7星·9星的「六翼」怪兽给对方观看
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,available_filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	
	-- 给对方观看
	Duel.ConfirmCards(1-tp,tc)
	
	-- 根据等级适用不同效果
	local lv=tc:GetLevel()
	
	if lv==9 then
		s.lv9effect(e,tp,eg,ep,ev,re,r,rp)
	elseif lv==7 then
		s.lv7effect(e,tp,eg,ep,ev,re,r,rp)
	elseif lv==6 then
		s.lv6effect(e,tp,eg,ep,ev,re,r,rp)
	end
end

-- 9星效果：双重嘲讽+保护未来战怪兽
function s.lv9effect(e,tp,eg,ep,ev,re,r,rp)
	-- 检查场上是否有六翼怪兽
	local g1=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x675)
	if #g1>0 then
		-- 对方必须把「六翼」怪兽作为攻击对象
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetCondition(s.atkcon)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_MUST_ATTACK_MONSTER)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetValue(s.atkval)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		
		-- 对方必须把「六翼」怪兽作为效果的对象
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(s.etarget)
		e3:SetValue(aux.tgoval)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
	
	-- 选自己场上1只未来战怪兽给予不被效果破坏的抗性
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_MZONE,0,1,1,nil,0x671)
	if #g2>0 then
		local tc=g2:GetFirst()
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
end

function s.atkcon(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,0x675)
end

function s.atkval(e,c)
	return c:IsSetCard(0x675)
end

function s.etarget(e,c)
	return not c:IsSetCard(0x675)
end

-- 7星效果：特殊召唤未来战+破坏（最多2张）
function s.lv7effect(e,tp,eg,ep,ev,re,r,rp)
	-- 特殊召唤墓地的未来战怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g1>0 then
		local tc1=g1:GetFirst()
		if Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)~=0 then
			-- 选场上最多2张卡（自己·对方场上各1张）破坏
			local dg=Group.CreateGroup()
			
			-- 选择自己场上的卡（0-1张）
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,0,1,nil)
			if #sg1>0 then
				dg:Merge(sg1)
			end
			
			-- 选择对方场上的卡（0-1张）
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,0,1,nil)
			if #sg2>0 then
				dg:Merge(sg2)
			end
			
			-- 破坏选择的卡
			if #dg>0 then
				Duel.HintSelection(dg)
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 6星效果：弹手+堆墓
function s.lv6effect(e,tp,eg,ep,ev,re,r,rp)
	-- 选对方场上1张卡回到手卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		-- 从卡组上面把3张卡送去墓地
		Duel.SendtoGrave(Duel.GetDecktopGroup(tp,3),REASON_EFFECT)
	end
end