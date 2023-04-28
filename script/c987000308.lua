--Rescuer of Melirria - Aki Matsuoka
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
s.listed_series={0x38d}
function s.tg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x3dd) and c:GetCode()~=id
	end
	function s.costfilter(c)
	return c:IsSetCard(0x3dd) and c:IsDiscardable()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local tg=g:FilterSelect(tp,Card.IsMonster,Card.IsSpell,Card.IsTrap,1,1,nil)
		local tc=tg:GetFirst()
		if tc then
			local c=tc:GetCardTarget()
			if e:GetLabel()==0 then g=Duel.SelectMatchingCard(1-tp,s.tgfilter,1-tp,LOCATION_HAND,0,1,1,nil,TYPE_MONSTER)
			elseif e:GetLabel()==1 then g=Duel.SelectMatchingCard(1-tp,s.tgfilter,1-tp,LOCATION_HAND,0,1,1,nil,TYPE_SPELL)
			else g=Duel.SelectMatchingCard(1-tp,s.tgfilter,1-tp,LOCATION_HAND,0,1,1,nil,TYPE_TRAP) 
			end
				Duel.Damage(1-tp,500,REASON_EFFECT)
			else
				Duel.Damage(tp,500,REASON_EFFECT)
			end
		end
		Duel.ShuffleHand(1-tp)
	end
end