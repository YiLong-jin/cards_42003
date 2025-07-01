--
function c22061304.initial_effect(c)
	--宇宙
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c22061304.spcon)
	c:RegisterEffect(e3)
	--宇宙2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22061304,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,22061304)
	e2:SetTarget(c22061304.thtg)
	e2:SetOperation(c22061304.thop)
	c:RegisterEffect(e2)
end
--1效果
function c22061304.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	return g:GetCount()>=4 and g:GetClassCount(Card.GetCode)==g:GetCount()
end
--宇宙
function c22061304.filter(c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c22061304.spconer(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22061304.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
--宇宙的奥义
function c22061304.thfilter(c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	return g:GetCount()>=4 and g:GetClassCount(Card.GetCode)==g:GetCount() and c:IsAbleToHand()
end
--fdV 破坏
function c22061304.fdV1nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and (not c:GetCode(EFFECT_INDESTRUCTABLE_EFFECT)) and (not c:IsImmuneToEffect(e))
end
function c22061304.fdV2nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsCanBeEffectTarget() and not c:GetCode(EFFECT_INDESTRUCTABLE_EFFECT) and not c:IsImmuneToEffect(e)
end
--fdR 控制权
function c22061304.fdR1nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsAbleToChangeControler() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not c:IsImmuneToEffect(e)
end
function c22061304.fdR2nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsCanBeEffectTarget() and c:IsAbleToChangeControler() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not c:IsImmuneToEffect(e)
end
--fdE 除外
function c22061304.fdE1nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove(REASON_EFFECT) and not c:IsImmuneToEffect(e) and c:IsOnField()
end
function c22061304.fdE2nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove(REASON_EFFECT) and c:IsCanBeEffectTarget() and not c:IsImmuneToEffect(e) and c:IsOnField()
end
--fdT 解放
function c22061304.fdT1nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and Duel.IsPlayerCanRelease(c)
end
function c22061304.fdT2nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsCanBeEffectTarget() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and Duel.IsPlayerCanRelease(c)
end
function c22061304.fdT3nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0 and Duel.IsPlayerCanSpecialSummon(tp)
end
function c22061304.fdT4nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.GetMZoneCount(1-tp,c,tp)>0 
end
--fdY 无效
function c22061304.fdY1nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)  and not c:IsDisabled() and not c:IsImmuneToEffect(e)
end
function c22061304.fdY2nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)  and not c:IsDisabled() and c:IsCanBeEffectTarget() and not c:IsImmuneToEffect(e)
end
--fdB 回手
function c22061304.fdB1nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)  and c:IsAbleToHand() and not c:IsImmuneToEffect(e)
end
function c22061304.fdB2nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)  and c:IsAbleToHand() and c:IsCanBeEffectTarget() and not c:IsImmuneToEffect(e)
end
--fdS 回卡组
function c22061304.fdS1nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)  and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c22061304.fdS2nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsHasCardTarget() and c:IsAbleToDeck() and c:IsCanBeEffectTarget() and not c:IsImmuneToEffect(e)
end
--fdA 检索 
function c22061304.fdA1nfilter(c)
	return c:IsAbleToHand()
end
--fdZ 抽卡
function c22061304.fdZ1nfilter(c)
	return Duel.IsPlayerCanDraw(tp)
end
--fdM 堆墓
function c22061304.fdM1nfilter(c)
	return Duel.IsPlayerCanSendtoGrave(tp)
end
--fdI 通招
function c22061304.fdI1nfilter(c)
	local e1=c:CheckActivateEffect(false,true,true)
	return e1:GetCode(EVENT_SUMMON_SUCCESS)
end
--死者苏生
function c22061304.fdM2nfilter(c)
	return Duel.IsPlayerCanSpecialSummon(tp)
end
--fdK 加攻击力
function c22061304.fdK1nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsFaceup() 
end
function c22061304.fdK2nfilter(c)
	local e=Effect.CreateEffect(c)
	return c:IsFaceup() and c:IsCanBeEffectTarget()
end
function c22061304.fdK3nfilter(c)
	return c:IsFaceup() 
end
--------------------------------------------------------
function c22061304.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22061304.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22061304.thop(e,tp,eg,ep,ev,re,r,rp)
	local sgee=Group.CreateGroup()
	local fadong=1
	local tezhao=1
	local maxes=0
	local rushou=1
	local sgee1=0
	local sgee2=0
	local sgee3=0
	--次等回收
	if maxes<=3 then 
	local g3=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		local tc=g3:GetFirst()
		while tc do
			--启动条件
			if rushou<=3 and maxes<=2 then
				--尽可能填充
				if tc:CheckActivateEffect(true,true,true) and not tc:IsType(TYPE_TRAP) then
					if sgee1==0 then
					sgee:AddCard(tc)
					rushou=rushou+1
					maxes=maxes+1
					sgee1=tc:GetOriginalCode()
					tc=g3:GetNext()
					elseif sgee2==0 and sgee1~=tc:GetOriginalCode() then
					sgee:AddCard(tc)
					rushou=rushou+1
					maxes=maxes+1
					sgee2=tc:GetOriginalCode()
					tc=g3:GetNext()
					elseif sgee3==0 and sgee2~=tc:GetOriginalCode() and sgee1~=tc:GetOriginalCode() then
					sgee:AddCard(tc)
					rushou=rushou+1
					maxes=maxes+1
					tc=g3:GetNext()
					else 
					tc=g3:GetNext() 
					end
				else 
					tc=g3:GetNext() 
				end
			else
				tc=g3:GetNext()
			end
		end
	   
		--回路测试
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		--local tg01=sgee:Select(tp,1,1,nil)
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		--local tg02=sgee:Select(tp,1,1,nil)
	end
-------------保底
	if maxes<=3 and rushou<=3 then
		local g9=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		local tc=g9:GetFirst()
		while tc do
			if rushou<=3 and maxes<=2 then
				if tc:IsType(TYPE_MONSTER) and tc:IsType(TYPE_EFFECT) then
				sgee:AddCard(tc)
				rushou=rushou+1
				maxes=maxes+1
				tc=g9:GetNext()
				elseif tc:IsType(TYPE_SPELL) then
				sgee:AddCard(tc)
				rushou=rushou+1
				maxes=maxes+1
				tc=g9:GetNext()
				else
				tc=g9:GetNext()
				end
			else
				tc=g9:GetNext()
			end
		end  
---------------------------最后一个循环 
		local g10=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		local tc=g10:GetFirst()
		while tc do
			if maxes<=2 and rushou<=3 then
				sgee:AddCard(tc)
				rushou=rushou+1
				maxes=maxes+1
				tc=g10:GetNext()
				else
				tc=g10:GetNext()
			end
		end
	end
	--local g4=sgee
	if sgee:GetCount()>=3 then
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		--local sg=sgee:Select(tp,3,3,nil) 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local tg=sgee:Select(tp,1,1,nil)
		--tg:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sgee)
		Duel.ShuffleDeck(tp)
	end
end
