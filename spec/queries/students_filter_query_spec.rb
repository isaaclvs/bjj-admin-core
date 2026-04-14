require "rails_helper"

RSpec.describe StudentsFilterQuery do
  let(:academy) { create(:academy) }

  def query(params = {})
    described_class.new(academy, params).call
  end

  describe "#call" do
    it "returns all academy students when no filters are applied" do
      s1 = create(:student, academy: academy)
      s2 = create(:student, academy: academy)
      expect(query).to include(s1, s2)
    end

    it "excludes students from other academies" do
      other = create(:student) # belongs to a different academy via factory
      expect(query).not_to include(other)
    end

    describe "filter by belt" do
      it "returns students matching the given belt" do
        blue   = create(:student, academy: academy, belt: :blue)
        purple = create(:student, academy: academy, belt: :purple)
        expect(query(belt: "blue")).to include(blue)
        expect(query(belt: "blue")).not_to include(purple)
      end

      it "ignores belt filter when blank" do
        blue = create(:student, academy: academy, belt: :blue)
        expect(query(belt: "")).to include(blue)
      end
    end

    describe "filter by status" do
      it "returns students matching the given status" do
        active   = create(:student, academy: academy, status: :active)
        inactive = create(:student, academy: academy, status: :inactive)
        expect(query(status: "active")).to include(active)
        expect(query(status: "active")).not_to include(inactive)
      end
    end

    describe "filter by risk (at_risk=1)" do
      it "returns only students with risk health records" do
        risky  = create(:student, academy: academy)
        create(:health_record, student: risky, comorbidities: [ "hipertensão" ])

        safe = create(:student, academy: academy)
        create(:health_record, student: safe, comorbidities: [])

        expect(query(at_risk: "1")).to include(risky)
        expect(query(at_risk: "1")).not_to include(safe)
      end

      it "does not apply risk filter when at_risk is not '1'" do
        safe = create(:student, academy: academy)
        create(:health_record, student: safe, comorbidities: [])
        expect(query(at_risk: "0")).to include(safe)
        expect(query).to include(safe)
      end
    end

    describe "search by name" do
      it "returns students whose names match the query" do
        joao  = create(:student, academy: academy, name: "João Silva")
        maria = create(:student, academy: academy, name: "Maria Oliveira")
        expect(query(q: "João")).to include(joao)
        expect(query(q: "João")).not_to include(maria)
      end

      it "is case-insensitive via LIKE wildcard" do
        joao = create(:student, academy: academy, name: "João Silva")
        expect(query(q: "silva")).to include(joao)
      end

      it "ignores search when q is blank" do
        joao = create(:student, academy: academy, name: "João Silva")
        expect(query(q: "")).to include(joao)
      end
    end

    describe "combined filters" do
      it "applies multiple filters together" do
        match = create(:student, academy: academy, belt: :blue, status: :active, name: "Carlos")
        no_match = create(:student, academy: academy, belt: :white, status: :active, name: "Carlos")

        results = query(belt: "blue", status: "active", q: "Carlos")
        expect(results).to include(match)
        expect(results).not_to include(no_match)
      end
    end
  end
end
