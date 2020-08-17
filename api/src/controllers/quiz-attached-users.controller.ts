import {repository} from '@loopback/repository';
import {param, get, getModelSchemaRef} from '@loopback/rest';
import {QuizAttached, Users} from '../models';
import {QuizAttachedRepository} from '../repositories';

export class QuizAttachedUsersController {
  constructor(
    @repository(QuizAttachedRepository)
    public quizAttachedRepository: QuizAttachedRepository,
  ) {}

  @get('/quiz-attacheds/{id}/users', {
    responses: {
      '200': {
        description: 'Users belonging to QuizAttached',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(Users)},
          },
        },
      },
    },
  })
  async getUsers(
    @param.path.number('id') id: typeof QuizAttached.prototype.id,
  ): Promise<Users> {
    return this.quizAttachedRepository.user(id);
  }
}
