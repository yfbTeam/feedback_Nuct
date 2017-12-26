using FEModel;
using FEUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FEHandler.SysClass
{
    /// <summary>
    /// ProfessInfoHandler 的摘要说明
    /// </summary>
    public class ProfessInfoHandler : IHttpHandler
    {

        JsonModel jsonModel = new JsonModel();
        public void ProcessRequest(HttpContext context)
        {
            HttpRequest Request = context.Request;
            string func = RequestHelper.string_transfer(Request, "func");
            try
            {
                switch (func)
                {
                    //获取所有课程
                    case "GetProfessInfo": GetProfessInfo(context); break;

                    default:
                        jsonModel = JsonModel.get_jsonmodel(5, "没有此方法", "");
                        context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
                        break;
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                jsonModel = JsonModel.get_jsonmodel(7, "出现异常,请通知管理员", "");
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }
        public void GetProfessInfo(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
             
                var query = from Major_ in Constant.Major_List
                            select new
                            {
                                College_Name = Major_.Major_Name,
                                Id =  Major_.Id,
                            };
                

                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", query);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}