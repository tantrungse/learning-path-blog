class ExpensesController < ApplicationController
  def new
    @expense = Expense.new
  end

  def create
    expense = Expense.create!(expense_params)
    redirect_to expense
  end

  def show
    @expense = Expense.find(params[:id])
  end

  
  def edit
    @expense = Expense.find(params[:id])
  end

  def update
    @expense = Expense.find(params[:id])
    if @expense.update(expense_params)
      redirect_to @expense
    else
      render :edit
    end
  end
  private

  def expense_params
    params.require(:expense).permit(:amount, :received_at, :receipt)
  end
end
