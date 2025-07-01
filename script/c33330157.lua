--信仰佳节的祝愿
function c33330157.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33330157+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33330157.tg1)
	e1:SetOperation(c33330157.op1)
	c:RegisterEffect(e1)
--
end
--
function c33330157.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33330157.ofilter1(c)
	return c:IsType(TYPE_MONSTER)
		and c:GetFlagEffect(33330157)<1 and not c:IsPublic()
end
function c33330157.ofilter2(c)
	return c:GetFlagEffect(33330157)>0
end
function c33330157.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	local sg=Duel.GetOperatedGroup()
	if sg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,sg)
		sg:GetFirst():RegisterFlagEffect(33330157,0,0,0)
		local p=1-tp
		while (Duel.IsExistingMatchingCard(c33330157.ofilter1,p,LOCATION_HAND,0,1,nil) or Duel.IsPlayerCanDraw(p,1)) do
			if not Duel.SelectYesNo(p,aux.Stringid(33330157,0)) then break end
			local off=1
			local ops={}
			local opval={}
			if Duel.IsExistingMatchingCard(c33330157.ofilter1,p,LOCATION_HAND,0,1,nil) then
				ops[off]=aux.Stringid(33330157,1)
				opval[off-1]=1
				off=off+1
			end
			if Duel.IsPlayerCanDraw(p,1) then
				ops[off]=aux.Stringid(33330157,2)
				opval[off-1]=2
				off=off+1
			end
			local op=Duel.SelectOption(p,table.unpack(ops))
			local sel=opval[op]
			if sel==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
				local lg=Duel.SelectMatchingCard(p,c33330157.ofilter1,p,LOCATION_HAND,0,1,1,nil)
				Duel.ConfirmCards(1-tp,lg)
				lg:GetFirst():RegisterFlagEffect(33330157,0,0,0)
			end
			if sel==2 then
				Duel.Draw(p,1,REASON_EFFECT)
				local lg=Duel.GetOperatedGroup()
				Duel.ConfirmCards(1-tp,lg)
				lg:GetFirst():RegisterFlagEffect(33330157,0,0,0)
			end
			p=1-p
		end
		local og=Duel.GetMatchingGroup(c33330157.ofilter2,tp,LOCATION_HAND,LOCATION_HAND,nil)
		if og:GetCount()>0 then
			local og1=og:Filter(Card.IsControler,nil,tp)
			local og2=og:Filter(Card.IsControler,nil,1-tp)
			if og1:GetCount()==1 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
			if og2:GetCount()==1 then
				Duel.Draw(1-tp,1,REASON_EFFECT)
			end
			local ag1=og1:Filter(Card.IsType,nil,TYPE_MONSTER)
			local ag2=og2:Filter(Card.IsType,nil,TYPE_MONSTER)
			local lv1=0
			local lv2=0
			for tc in aux.Next(ag1) do
				lv1=lv1+tc:GetLevel()
			end
			for tc in aux.Next(ag2) do
				lv2=lv2+tc:GetLevel()
			end
			if lv1>lv2 then
				if ag1:GetCount()>2 then
					Duel.Draw(tp,1,REASON_EFFECT)
					Duel.Damage(1-tp,(lv1+lv2)*50,REASON_EFFECT)
				end
				if ag2:GetCount()>2 then
					Duel.Draw(tp,1,REASON_EFFECT)
					Duel.Damage(1-tp,(lv1+lv2)*50,REASON_EFFECT)
				end
			end
			if lv1<lv2 then
				if ag1:GetCount()>2 then
					Duel.Draw(1-tp,1,REASON_EFFECT)
					Duel.Damage(tp,(lv1+lv2)*50,REASON_EFFECT)
				end
				if ag2:GetCount()>2 then
					Duel.Draw(1-tp,1,REASON_EFFECT)
					Duel.Damage(tp,(lv1+lv2)*50,REASON_EFFECT)
				end
			end
			for tc in aux.Next(og) do
				tc:ResetFlagEffect(33330157)
			end
			Duel.SendtoDeck(og,nil,2,REASON_EFFECT)
		end
	end
end
