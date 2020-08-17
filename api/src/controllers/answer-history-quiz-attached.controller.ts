import {repository} from '@loopback/repository';
import {param, get, getModelSchemaRef} from '@loopback/rest';
import {AnswerHistory, QuizAttached} from '../models';
import {AnswerHistoryRepository} from '../repositories';

export class AnswerHistoryQuizAttachedController {
  constructor(
    @repository(AnswerHistoryRepository)
    public answerHistoryRepository: AnswerHistoryRepository,
  ) {}

  @get('/answer-histories/{id}/quiz-attached', {
    responses: {
      '200': {
        description: 'QuizAttached belonging to AnswerHistory',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(QuizAttached)},
          },
        },
      },
    },
  })
  async getQuizAttached(
    @param.path.number('id') id: typeof AnswerHistory.prototype.id,
  ): Promise<QuizAttached> {
    return this.answerHistoryRepository.quiz(id);
  }
}
