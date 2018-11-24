class ReportsController < ApplicationController

  def create
    @report = Report.new(total_request: 0, true_answer: 0,
                         false_answer: 0, flag: params[:flag_id])
    @report.save
    if @report.save
      render json: {data: 'Correct create'}, status: :ok
    else
      return render json: {data: 'Error create faile'}, status: 400
    end
  end

  def update_result
    report = Report.find_by(flag: params[:token])
    return render json: {data: 'Error report not found'}, status: 400 if report.nil?

    report.total_request = report.total_request + 1
    if params[:result]
      report.true_answer = report.true_answer + 1
    else
      report.false_answer = report.false_answer + 1
    end
    report.save
    if report.save
      render json: {data: 'Correct update'}, status: :ok
    else
      return render json: {data: 'Error update faile'}, status: 400
    end
  end

  def update_time
    report = Report.find_by(flag: params[:token])
    return render json: {data: 'Error report not found'}, status: 400 if report.nil?

    report.total_time = report.total_time + params[:time]

    if report.save
      render json: {data: 'Correct update'}, status: :ok
    else
      return render json: {data: 'Error update faile'}, status: 400
    end
  end


  def show_json
    report = Report.find_by(flag: params[:token])
    return render json: {data: 'Error report not found'}, status: 400 if report.nil?

    json_report = get_json(report)
    render json: {data: json_report}, status: :ok
  end

  def show
    report = Report.find_by(flag: params[:token])
    return render json: {data: 'Error report not found'}, status: 400 if report.nil?

    render json: report, status: :ok
  end

  private

  def get_json(report)
    method_return = {'Total' => report.total_request,
                     'Positive' => (report.total_request.positive? ? (report.true_answer * 100) / report.total_request : 0),
                     'Negative' => (report.total_request.positive? ? (report.false_answer * 100) / report.total_request : 0),
                     'Positive/Negative Rate' => (report.false_answer.positive? ? report.true_answer / report.false_answer : report.true_answer),
                     'Average Response Time' => (report.total_request.positive? ? report.total_time / report.total_request : 0)}
    method_return
  end

end
