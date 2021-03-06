# -*- coding: utf-8 -*-
# frozen_string_literal: true
require "spec_helper"
require "zip"

module Decidim
  describe ExportMailer, type: :mailer do
    let(:user) { create(:user, name: "Sarah Connor", organization: organization) }
    let!(:organization) { create(:organization) }
    let(:export_data) { double(read: "content", extension: "txt") }

    describe "export" do
      let(:mail) { described_class.export(user, "dummy", export_data) }

      it "sets a subject" do
        expect(mail.subject).to include("dummy", "ready")
      end

      it "zips the export" do
        expect(mail.attachments.length).to eq(1)

        attachment = mail.attachments.first
        expect(attachment.filename).to eq("dummy.zip")

        entries = []
        Zip::InputStream.open(StringIO.new(attachment.read)) do |io|
          while (entry = io.get_next_entry)
            entries << { name: entry.name, content: entry.get_input_stream.read }
          end
        end

        expect(entries.length).to eq(1)

        entry = entries.first
        expect(entry[:name]).to eq("dummy.txt")
        expect(entry[:content]).to eq("content")
      end
    end
  end
end
