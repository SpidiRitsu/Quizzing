import {repository} from '@loopback/repository';
import {param, get, getModelSchemaRef} from '@loopback/rest';
import {Questions, QuizOwners} from '../models';
import {QuestionsRepository} from '../repositories';

export class QuestionsQuizOwnersController {
  constructor(
    @repository(QuestionsRepository)
    public questionsRepository: QuestionsRepository,
  ) {}

  @get('/questions/{id}/quiz-owners', {
    responses: {
      '200': {
        description: 'QuizOwners belonging to Questions',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(QuizOwners)},
          },
        },
      },
    },
  })
  async getQuizOwners(
    @param.path.number('id') id: typeof Questions.prototype.id,
  ): Promise<QuizOwners> {
    return this.questionsRepository.quiz(id);
  }
}
