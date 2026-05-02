require "rails_helper"

RSpec.describe Academy, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:users).dependent(:destroy) }
    it { is_expected.to have_many(:students).dependent(:destroy) }
    it { is_expected.to have_many(:plans).dependent(:destroy) }
    it { is_expected.to have_many(:payments).through(:enrollments) }
  end

  describe "validations" do
    subject { build(:academy) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:slug) }

    it "rejects a blank slug that was set explicitly after creation" do
      academy = create(:academy)
      academy.slug = ""
      expect(academy).not_to be_valid
    end
  end

  describe "slug generation" do
    it "generates a slug from name on create" do
      academy = create(:academy, name: "Academia Teste", slug: nil)
      expect(academy.slug).to eq("academia-teste")
    end

    it "does not overwrite a manually set slug" do
      academy = create(:academy, name: "Academia Teste", slug: "minha-academia")
      expect(academy.slug).to eq("minha-academia")
    end
  end

  describe "slug format validation" do
    it "rejects slugs with uppercase letters" do
      academy = build(:academy, slug: "Academia-Teste")
      expect(academy).not_to be_valid
    end

    it "rejects slugs with spaces" do
      academy = build(:academy, slug: "academia teste")
      expect(academy).not_to be_valid
    end

    it "accepts lowercase letters, numbers and hyphens" do
      academy = build(:academy, slug: "academia-123")
      expect(academy).to be_valid
    end
  end
end
