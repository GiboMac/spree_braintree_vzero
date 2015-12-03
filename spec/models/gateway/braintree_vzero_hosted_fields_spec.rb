require 'spec_helper'

describe Spree::Gateway::BraintreeVzeroHostedFields, :vcr do
  subject { create(:vzero_hosted_fields_gateway) }

  describe 'after_save' do
    let(:dropin_ui_gateway) { create(:vzero_dropin_ui_gateway) }
    let(:vzero_hosted_fields_gateway_2) { create(:vzero_hosted_fields_gateway_2) }

    it 'activation should disable DropIn UI Gateways' do
      subject.update_column(:active, false)
      expect(dropin_ui_gateway).to be_active
      subject.update(active: true)
      expect(dropin_ui_gateway.reload).to_not be_active
    end

    it 'activation should disable other Hosted fields Gateways' do
      create(:vzero_hosted_fields_gateway_2)
      expect(subject).to be_active
      vzero_hosted_fields_gateway_2.update(active: true)
      expect(subject.reload).to_not be_active
    end

    it 'deactivation should not disable DropIn UI Gateways' do
      subject
      expect(dropin_ui_gateway).to be_active
      subject.update(active: false)
      expect(dropin_ui_gateway.reload).to be_active
    end

    it 'creation of activated should disable DropIn UI Gateways' do
      expect(dropin_ui_gateway).to be_active
      subject
      expect(dropin_ui_gateway.reload).to_not be_active
    end

    it 'creation of deactivated should not disable DropIn UI Gateways' do
      expect(dropin_ui_gateway).to be_active
      create(:vzero_dropin_ui_gateway, active: false)
      expect(dropin_ui_gateway.reload).to be_active
    end
  end
end
