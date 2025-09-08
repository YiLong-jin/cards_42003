--溶解衣服的感染者 2025/09/03 12:57:29 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,71100771)
	aux.AddLinkProcedure(c,nil,2,3,this.lcheck)
	--①效果：指定，然后连接召唤
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(this.condition1)
	e1:SetTarget(this.lktg)
	e1:SetOperation(this.lkop)
	c:RegisterEffect(e1)
	--结束阶段返回卡组并特殊召唤
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,id+1)
	e4:SetCondition(this.tdcon)
	e4:SetTarget(this.tdtg)
	e4:SetOperation(this.tdop)
	c:RegisterEffect(e4)
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
--①效果目标：选择区域
function this.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sq=Duel.SelectField(tp,2,0,LOCATION_ONFIELD,0xe0e0e0e0)
	e:SetLabel(sq)
	Duel.Hint(HINT_ZONE,tp,sq)
	Duel.Hint(HINT_ZONE,1-tp,sq)
end
--①效果操作：连接召唤
function this.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=e:GetLabel()
	if tp==1 then
		zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetLabel(zone)
	e1:SetOperation(this.rmop)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		e1:SetReset(RESET_PHASE+PHASE_MAIN1)
	else
		e1:SetReset(RESET_PHASE+PHASE_MAIN2)
	end
	Duel.RegisterEffect(e1,tp)
	--连接召唤
	local lkg=Duel.GetMatchingGroup(this.lkfilter,tp,LOCATION_EXTRA,0,nil)
	if #lkg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=lkg:Select(tp,1,1,nil):GetFirst()
		if sc then
			Duel.LinkSummon(tp,sc,nil)
		end
	end
end
function this.checkzone(tc,zone,tp)
	local seq=tc:GetSequence()
	-- 检查是否移动到指定的区域
	local check_zone=0
	if tc:IsLocation(LOCATION_MZONE) then
		if seq<5 then check_zone=0x1<<(seq+16*(1-tp)) end -- 主怪兽区
	else
		if seq<5 then check_zone=0x100<<(seq+16*(1-tp)) end -- 魔法陷阱区
	end
	return (zone&check_zone)~=0 
end 
function this.rmop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetLabel()
	local fg=Duel.GetMatchingGroup(this.checkzone,tp,0,LOCATION_ONFIELD,nil,zone,tp)
	if #fg>0 then Duel.SendtoGrave(fg,REASON_EFFECT) end 
end
--连接召唤过滤器：有「感染者衍生物」记述的连接怪兽
function this.lkfilter(c)
	return c:IsType(TYPE_LINK) and aux.IsCodeListed(c,71100771) and c:IsLinkSummonable(nil)
end
--效果条件：对方结束阶段
function this.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function this.spfilter(c,e,tp)
	return aux.IsCodeListed(c,71100771) and c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function this.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(this.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function this.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 
	or not c:IsLocation(LOCATION_EXTRA) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,this.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
