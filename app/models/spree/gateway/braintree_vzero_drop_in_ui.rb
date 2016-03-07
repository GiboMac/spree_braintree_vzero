module Spree
  class Gateway::BraintreeVzeroDropInUI < Spree::Gateway::BraintreeVzeroBase
    preference :dropin_container, :string, default: 'payment-form'
    preference :checkout_form_id, :string, default: 'checkout_form_payment'
    preference :error_messages_container_id, :string, default: 'content'
    preference :store_payments_in_vault, :select, default: { values: [:do_not_store, :store_only_on_success, :store_all] }
    preference :'3dsecure', :boolean_select, default: false

    after_save :disable_hosted_gateways, if: proc { active? && (active_changed? || id_changed?) }

    def method_type
      'braintree_vzero_dropin_ui'
    end

    private

    def disable_hosted_gateways
      Spree::Gateway::BraintreeVzeroHostedFields.update_all(active: false)
      Spree::Gateway::BraintreeVzeroDropInUI.where.not(id: id).update_all(active: false)
    end
  end
end
