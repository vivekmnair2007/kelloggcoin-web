class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all.includes(:from_user, :to_user)
    @balances = calculate_balances
    render :template => "transactions/index"
  end

  private

  def calculate_balances
    balances = Hash.new(0)

    Transaction.all.each do |transaction|
      to_user = User.find_by(id: transaction.to_user_id)
      from_user = User.find_by(id: transaction.from_user_id)

      balances[to_user.name] += transaction.amount if to_user
      balances[from_user.name] -= transaction.amount if from_user
    end

    balances
  end
end
