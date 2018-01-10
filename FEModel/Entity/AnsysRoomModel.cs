using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class AnsysRoomModel
    {
        public List<Score_Model> Score_ModelList { get; set; }

        public List<AnswerScore_Model> AnswerScore_ModelList { get; set; }

        public List<HeaderModel> HeaderModelList { get; set; }
    }
}
