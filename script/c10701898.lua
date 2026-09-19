--异变的食人虫
function c10701898.initial_effect(c)
	aux.AddCodeList(c,10701896)
	-- 不能通常召唤，用卡的效果才能特殊召唤。
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c10701898.splimit)
	c:RegisterEffect(e0)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701898,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10701898)
	e1:SetTarget(c10701898.sptg)
	e1:SetOperation(c10701898.spop)
	c:RegisterEffect(e1)
	--To hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701898,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10701899)
	e2:SetTarget(c10701898.thtg)
	e2:SetOperation(c10701898.thop)
	c:RegisterEffect(e2)
end
function c10701898.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c10701898.spfilter(c,tp)
	-- 核心修正：使用 IsReleasableByEffect，确保对方怪兽可以合法作为效果对象被选中
	return c:IsReleasableByEffect() and Duel.GetMZoneCount(tp,c,tp)>0
end

function c10701898.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10701898.spfilter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then 
		-- 发动条件只做纯粹的特召可能性判定与目标筛选，参考参考卡22020130的流畅逻辑
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingTarget(c10701898.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c10701898.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c10701898.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	if not c:IsRelateToEffect(e) then return end
	if tc and tc:IsRelateToEffect(e) then
		-- 执行效果解放
		if Duel.Release(tc,REASON_EFFECT)>0 then
			-- 【核心修正】：只有在特殊召唤成功后（返回值不为0），才进行自肃的注册
			if Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)~=0 then
				-- 成功特招，施加昆虫族自锁限制
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				e1:SetDescription(aux.Stringid(10701898,2))
				e1:SetTargetRange(1,0)
				e1:SetTarget(c10701898.splimit2)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c10701898.splimit2(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_INSECT)
end

-- --- ② 检索效果相关 ---
function c10701898.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,10701896) and c:IsAbleToHand()
end
function c10701898.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701898.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701898.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10701898.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end