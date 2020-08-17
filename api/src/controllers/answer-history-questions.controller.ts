import {repository} from '@loopback/repository';
import {param, get, getModelSchemaRef} from '@loopback/rest';
import {AnswerHistory, Questions} from '../models';
import {AnswerHistoryRepository} from '../repositories';

export class AnswerHistoryQuestionsController {
  constructor(
    @repository(AnswerHistoryRepository)
    public answerHistoryRepository: AnswerHistoryRepository,
  ) {}

  @get('/answer-histories/{id}/questions', {
    responses: {
      '200': {
        description: 'Questions belonging to AnswerHistory',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(Questions)},
          },
        },
      },
    },
  })
  async getQuestions(
    @param.path.number('id') id: typeof AnswerHistory.prototype.id,
  ): Promise<Questions> {
    return this.answerHistoryRepository.question(id);
  }
}
