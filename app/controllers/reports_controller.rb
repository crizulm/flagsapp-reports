class ReportsController < ApplicationController

  def index; end

  def show
    flag = Flag.where(auth_token: params[:id]).first
    return render json: { data: 'Error flag not found' }, status: 400 if flag.nil?

    report = Report.where(flag_id: flag.id).first
    json_report = get_json(report)
    render json: { data: json_report }, status: :ok
  end

  def create_report
    @report = Report.new(total_request: 0, true_answer: 0,
                         false_answer: 0, flag: request.headers['flag-id'])
    @report.save
    render json: { data: "create" }, status: :ok
  end

  def update_report
    report = Report.where(flag: request.headers['flag-id']).first
    report.total_request = report.total_request + 1
    report.save
    render json: { data: "update" }, status: :ok
  end


  def get_json_report
    report = Report.where(flag: request.headers['flag-id']).first
    json_report = get_json(report)
    render json: { data: json_report }, status: :ok
  end

  def get_report
    report = Report.where(flag: request.headers['flag-id']).first
    render json: report, status: :ok
  end

  private

  def get_json(report)
    method_return = { 'Total' => report.total_request,
                      'Positive' => (report.total_request.positive? ? (report.true_answer * 100) / report.total_request : 0),
                      'Negative' => (report.total_request.positive? ? (report.false_answer * 100) / report.total_request : 0),
                      'Positive/Negative Rate' => (report.false_answer.positive? ? report.true_answer / report.false_answer : report.true_answer),
                      'Average Response Time' => (report.total_request.positive? ? report.total_time / report.total_request : 0) }
    method_return
  end

end
