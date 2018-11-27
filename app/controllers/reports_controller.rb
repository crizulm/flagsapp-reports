class ReportsController < ApplicationController
  def create
    token = params[:token]
    return render json: ['The flag token is NULL'], status: :bad_request if token.nil?

    @report = Report.new(total_request: 0, true_answer: 0,
                         false_answer: 0, total_time: 0,
                         flag: token)

    if @report.save
      render json: @report, status: :ok
    else
      errors = @report.errors.full_messages
      render json: errors, status: :bad_request
    end
  end

  def show
    token = params[:token]
    report = Report.find_by(flag: token)
    return render json: ['The report for flag ' + token + ' not found'], status: :bad_request if report.nil?

    render json: report, status: :ok
  end

  def show_json
    token = params[:token]
    report = Report.find_by(flag: token)
    return render json: ['The report for flag ' + token + ' not found'], status: :bad_request if report.nil?

    json_report = get_json(report)
    render json: json_report, status: :ok
  end

  def update_result
    token = params[:token]
    result = params[:result]
    return render json: ['The flag evaluate result is NULL'], status: :bad_request if result.nil?

    report = Report.find_by(flag: token)
    return render json: ['The report for flag ' + token + ' not found'], status: :bad_request if report.nil?

    report.total_request = report.total_request + 1
    if result
      report.true_answer = report.true_answer + 1
    else
      report.false_answer = report.false_answer + 1
    end

    if report.save
      render json: report, status: :ok
    else
      errors = @report.errors.full_messages
      render json: errors, status: :bad_request
    end
  end

  def update_time
    token = params[:token]
    time = params[:time]
    return render json: ['The flag evaluate time is NULL'], status: :bad_request if time.nil?

    report = Report.find_by(flag: token)
    return render json: ['The report for flag ' + token + ' not found'], status: :bad_request if report.nil?

    report.total_time = report.total_time + time

    if report.save
      render json: report, status: :ok
    else
      errors = @report.errors.full_messages
      render json: errors, status: :bad_request
    end
  end

  private

  def get_json(report)
    method_return = { 'total' => report.total_request,
                      'positive' => (report.total_request.positive? ? (report.true_answer * 100) / report.total_request : 0),
                      'negative' => (report.total_request.positive? ? (report.false_answer * 100) / report.total_request : 0),
                      'rate' => (report.false_answer.positive? ? report.true_answer / report.false_answer : report.true_answer),
                      'average_response_time' => (report.total_request.positive? ? report.total_time / report.total_request : 0) }
    method_return
  end
end
