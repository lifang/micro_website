#encoding: utf-8
class FormDatasController < ApplicationController

  #下载表单数据
  def download_form_data
    #page_id
    @page = Page.find_by_id params[:page_id]
    @form_datas = FormData.find_all_by_page_id(params[:page_id])
    format.xls {
      send_data(xls_content_for(@form_datas, @page),
        :type => "text/excel;charset=utf-8; header=present",
        :filename => "form_#{params[:page_id]}.xls")
    }
  end

  private

  def xls_content_for(objs, page)
    xls_report = StringIO.new
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "form_datas_#{page}"
    sheet1.row(0).concat page.element_relation.values
    count_row = 1
    objs.each do |obj|
      sheet1[count_row,0] = obj.name
      sheet1[count_row,1] = Staff::N_COMPANY[obj.type_of_w]
      sheet1[count_row,2] = obj.base_salary
      #salary = obj.salaries.where("current_month = #{(current_month.delete '-').to_i}").first
      sheet1[count_row,3] = obj.reward_num
      sheet1[count_row,4] = obj.deduct_num
      sheet1[count_row,5] = obj.total
      count_row += 1
    end
    book.write xls_report
    xls_report.string
  end
end