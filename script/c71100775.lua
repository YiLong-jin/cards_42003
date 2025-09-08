--喜欢殴打的感染者 2025/09/03 03:43:10 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,71100771)
	aux.AddLinkProcedure(c,nil,2,2,this.lcheck)
	--①效果：里侧表示或破坏，然后连接召唤
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(this.condition1)
	e1:SetTarget(this.lktg)
	e1:SetOperation(this.lkop)
	c:RegisterEffect(e1)
	--②效果：结束阶段回卡组
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(this.tdcon)
	e2:SetTarget(this.tdtg)
	e2:SetOperation(this.tdop)
	c:RegisterEffect(e2)
end

--连接素材要求：包含「感染者衍生物」的怪兽2只
function this.lfilter(c)
	return c:IsCode(71100771)
end
function this.lcheck(g)
	return g:IsExists(this.lfilter,1,nil)
end

--①效果条件：自己·对方主要阶段
function this.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end

--①效果目标：选择怪兽
function this.lktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

--①效果操作：里侧表示或破坏，然后连接召唤
function this.lkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	
	local op=0
	if tc:IsCanTurnSet() then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	else
		op=1
	end
	
	local success=false
	if op==0 then
		if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then
			success=true
		end
	else
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			success=true
		end
	end
	
	--那之后：连接召唤（参考来自星遗物的觉醒）
	if success then
		local lkg=Duel.GetMatchingGroup(this.lkfilter,tp,LOCATION_EXTRA,0,nil)
		if #lkg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=lkg:Select(tp,1,1,nil):GetFirst()
			if sc then
				Duel.LinkSummon(tp,sc,nil)
			end
		end
	end
end

--连接召唤过滤器：有「感染者衍生物」记述的连接怪兽
function this.lkfilter(c)
	return c:IsType(TYPE_LINK) and aux.IsCodeListed(c,71100771) and c:IsLinkSummonable(nil)
end

--②效果条件：对方结束阶段
function this.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end

--②效果目标：墓地2张卡回卡组（包含自身）
function this.tdfilter(c)
	return c:IsAbleToDeck()
end
function this.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingMatchingCard(this.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE)
end

--②效果操作：回卡组
function this.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsAbleToDeck() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,this.tdfilter,tp,LOCATION_GRAVE,0,1,1,c)
	if #g>0 then
		g:AddCard(c)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
