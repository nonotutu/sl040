class BankToUsers < ActiveRecord::Migration

  def change
    add_column :volunteers, :bank_account, :string
  end

end
