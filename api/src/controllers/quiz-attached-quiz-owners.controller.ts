import {repository} from '@loopback/repository';
import {param, get, getModelSchemaRef} from '@loopback/rest';
import {QuizAttached, QuizOwners} from '../models';
import {QuizAttachedRepository} from '../repositories';

export class QuizAttachedQuizOwnersController {
  constructor(
    @repository(QuizAttachedRepository)
    public quizAttachedRepository: QuizAttachedRepository,
  ) {}

  @get('/quiz-attacheds/{id}/quiz-owners', {
    responses: {
      '200': {
        description: 'QuizOwners belonging to QuizAttached',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(QuizOwners)},
          },
        },
      },
    },
  })
  async getQuizOwners(
    @param.path.number('id') id: typeof QuizAttached.prototype.id,
  ): Promise<QuizOwners> {
    return this.quizAttachedRepository.quiz(id);
  }
}
