# coding: utf-8
# frozen_string_literal: true
require "spec_helper"

module Decidim
  module Admin
    describe CategoryForm do
      let(:name) do
        {
          en: "Name",
          es: "Nombre",
          ca: "Nom"
        }
      end
      let(:description) do
        {
          en: "Description",
          es: "Descripción",
          ca: "Descripció"
        }
      end
      let(:parent_id) { nil }
      let(:attributes) do
        {
          "category" => {
            "name_en" => name[:en],
            "name_es" => name[:es],
            "name_ca" => name[:ca],
            "parent_id" => parent_id,
            "description_en" => description[:en],
            "description_es" => description[:es],
            "description_ca" => description[:ca]
          }
        }
      end
      let(:organization) { create :organization }
      let(:participatory_process) { create :participatory_process, organization: organization }

      subject do
        described_class.from_params(
          attributes
        ).with_context(
          current_process: participatory_process,
          current_organization: organization
        )
      end

      context "when everything is OK" do
        it { is_expected.to be_valid }
      end

      context "when some language in name is missing" do
        let(:name) do
          {
            en: "Name",
            ca: "Nombre"
          }
        end

        it { is_expected.to be_invalid }
      end

      context "when some language in description is missing" do
        let(:description) do
          {
            ca: "Descripció"
          }
        end

        it { is_expected.to be_invalid }
      end

      context "when the parent_id is set" do
        context "to the ID of a first-class category" do
          let!(:category) { create :category, participatory_process: participatory_process }
          let(:parent_id) { category.id }

          it { is_expected.to be_valid }
        end

        context "to the ID of a subcategory" do
          let!(:subcategory) { create :subcategory }
          let(:parent_id) { subcategory.id }

          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
